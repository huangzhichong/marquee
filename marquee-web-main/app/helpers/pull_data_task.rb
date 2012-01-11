class PullDataTask
  include JiraQueries

  def initialize(config_id)
    @config_id = config_id
  end
  
  def for_version_tracking_report
    config = Report::VersionTrackingConfig.find(@config_id)
    unless config.nil?
      # first get basic information for all tickets belongs to the version specified
      FndJira.connection.execute(get_project_version_requirements_and_top_level_tasks(config.jira_project, config.jira_versions)).each do |result|
        issue = create_jira_issue_from_db_result(result)
        config.issues << issue
      end
      config.save

      FndJira.connection.execute(get_project_version_sub_tasks(config.issues.collect{|i| i.jira_id})).each do |result|
        issue = create_jira_issue_from_db_result(result)
        parent_id = result[12].to_i
        parent_issue = config.issues.where(jira_id: parent_id).first
        if parent_issue.nil?
          
        else
          parent_issue.children << issue
          issue.parent = parent_issue
          config.issues << issue

          issue.save
          parent_issue.save
        end
      end
      config.save

      jira_ids = config.issues.collect{|issue| issue.jira_id}
      FndJira.connection.execute(get_work_logs_for_issues(jira_ids, config.start_date, config.end_date+1.days)).each do |result|
        issue = config.issues.where(jira_id: result[5].to_i).first
        work_log = issue.work_logs.build
        work_log.jira_id = result[0].to_i
        work_log.start_date = result[1]
        work_log.update_date = result[2]
        work_log.author = result[3]
        work_log.time_worked = result[4].to_i
        work_log.save
      end

      FndJira.connection.execute(get_change_items_for_issues(jira_ids, config.start_date, config.end_date+1.days)).each do |result|
        issue = config.issues.where(jira_id: result[8]).first
        change_item = issue.change_items.build
        change_item.jira_field = result[1]
        change_item.jira_id = result[0].to_i
        change_item.old_value = result[2]
        change_item.new_value = result[3]
        change_item.old_string = result[4]
        change_item.new_string = result[5]
        change_item.author = result[6]
        change_item.change_date = result[7]
        change_item.save
      end
    end

  end

  def for_in_development_tracking_report
    config = Report::InDevelopmentTrackingConfig.find(@config_id)
    unless config.nil?
      tracking = config.trackings.build
      jira_group = config.jira_group
      start_date = config.start_date
      end_date = config.end_date
      jira_project = config.jira_project
      jira_version = config.jira_version
      jira_key = config.jira_key

      tracking.total_time_worked = FndJira.connection.execute(get_work_done_in_total_by_group_and_date_range(jira_group, start_date, end_date)).first[0]
      tracking.out_of_release_time_worked = FndJira.connection.execute(get_work_done_out_of_version_by_group_and_date_range_and_version(jira_group, start_date, end_date, jira_project, jira_version)).first[0]
      tracking.out_of_project_time_worked = FndJira.connection.execute(get_work_done_out_of_project_by_group_and_date_range(jira_group, start_date, end_date, jira_project)).first[0]
      
      (tracking.out_of_project_time_worked = 0)  if tracking.out_of_project_time_worked.nil?
      (tracking.total_time_worked = 0) if tracking.total_time_worked.nil?
      (tracking.out_of_release_time_worked = 0) if tracking.out_of_release_time_worked.nil?
      
      tracking.in_release_time_worked = tracking.total_time_worked - tracking.out_of_release_time_worked - tracking.out_of_project_time_worked

      tracking.pulled_at = DateTime.now

      results = FndJira.connection.execute(get_work_logs_by_group_and_date_range(config.jira_group, config.start_date, config.end_date, config.jira_version))
    
      # result:
      #   0: worklog.id
      #   1: worklog.author
      #   2: worklog.issueid
      #   3: worklog.startdate
      #   4: worklog.timeworked
      #   5: jiraissue.pkey
      #   6: issuetype.pname
      #   7: 'release version' is not null
      #   8: Market
      #   9: Environment was found
      results.each do |result|
        work_log = tracking.work_logs.where(jira_id: result[0].to_i.to_s).first
        work_log = tracking.work_logs.build() if work_log.nil?
        work_log.jira_id = result[0].to_i.to_s
        work_log.start_date = result[3]
        work_log.worker = result[1]
        work_log.sub_task_key = result[5]
        work_log.time_worked = result[4].to_i
        work_log.in_release = result[7]
        work_log.category = result[6]
        work_log.market = result[8]
        work_log.environment = result[9]
        work_log.save
      end

      total_open_bugs_count = FndJira.connection.execute(get_total_open_bugs_count(jira_key)).first[0]
      open_bugs_count_by_priority = FndJira.connection.execute(get_open_bugs_count_by_priority(jira_key))

      tracking.p0_open_bugs_count = 0
      tracking.p1_open_bugs_count = 0
      tracking.p2_open_bugs_count = 0
      tracking.p3_open_bugs_count = 0
      tracking.p4_open_bugs_count = 0

      open_bugs_count_by_priority.each do |result|
        case result[0].to_i
        when 1
          tracking.p0_open_bugs_count = result[1]
        when 2
          tracking.p1_open_bugs_count = result[1]
        when 3
          tracking.p2_open_bugs_count = result[1]
        when 4
          tracking.p3_open_bugs_count = result[1]  
        when 5
          tracking.p4_open_bugs_count = result[1]
        end
      end

      tmp = ""
      (start_date .. Date.today).each do |day|
        tmp += day.to_date.to_s
        tmp += '|'
        tmp += FndJira.connection.execute(get_bugs_created_by_day(jira_key, day)).first[0].to_i.to_s
        tmp += ';'
      end
      
      tracking.daily_open_bugs_count_string = tmp
      tracking.save
    end
  end

  private

  def create_jira_issue_from_db_result(result)
    issue = nil
    case result[3]
    when 'Requirement/ User Story'
      issue = Jira::Requirement.new
    when 'Task'
      issue = Jira::Task.new
    when 'Dev Task'
      issue = Jira::DevTask.new
    when 'QA Task'
      issue = Jira::QaTask.new
    when 'Bug'
      issue = Jira::Bug.new
    when 'Automation Task'
      issue = Jira::AutomationTask.new  
    when 'Bug Sub-Task'
      issue = Jira::BugSubTask.new
    when 'Dev Sub-Task'
      issue = Jira::DevSubTask.new
    when 'QA Sub-Task'
      issue = Jira::QaSubTask.new
    when 'Automation Sub-Task'
      issue = Jira::AutomationSubTask.new
    end
    issue.jira_id = result[0].to_i
    issue.summary = result[1]
    issue.status = result[2]
    issue.issue_type = result[3]
    issue.priority = result[4]
    issue.key = result[5]
    issue.assignee = result[6]
    issue.created_at = result[7]
    issue.updated_at = result[8]
    issue.time_original_estimate = result[9].to_i
    issue.time_estimate = result[10].to_i
    issue.time_spent = result[11].to_i
    issue.save
    issue
  end

  def get_change_items_for_issues(jira_ids, start_date, end_date)
    "
    select ci.ID,
       ci.field,
       ci.oldvalue,
       ci.newvalue,
       ci.oldstring,
       ci.newstring,
       cg.author,
       cg.created,
       cg.issueid
    from changeitem ci
      join changegroup cg on ci.groupid=cg.id and cg.issueid in (#{jira_ids.join(',')})
    where ci.field='status' and cg.created >= DATE('#{start_date}') and cg.created <= DATE('#{end_date}')
    ;
    "
  end

  def get_work_logs_for_issues(jira_ids, start_date, end_date)
    "
    select wl.id,
           wl.startdate,
           wl.updated,
           wl.author,
           wl.timeworked,
           j1.id
    from worklog wl
      join jiraissue j1 on j1.id = wl.issueid and j1.id in (#{jira_ids.join(',')})
    where wl.startdate >= DATE('#{start_date}') and wl.startdate <= DATE('#{end_date}')
    ;
    "
  end

  def get_project_version_requirements_and_top_level_tasks(jira_project, jira_versions)
    # 1: Bug
    # 14: Requirement
    # 3: Task
    # 38: Automation Task
    # 8: Dev Task
    # 9: QA Task
    version_conditions = jira_versions.collect{|version| "pv.vname='#{version}'"}.join(' or ')
    "
    select
      j1.id,
      j1.summary,
      ist.pname,
      it.pname,
      pri.pname,
      j1.pkey,
      j1.assignee,
      j1.created,
      j1.updated,
      j1.timeoriginalestimate,
      j1.timeestimate,
      j1.timespent
        from jiraissue j1
          join issuetype it on it.id = j1.issuetype and it.id in (1, 14, 3, 38, 8, 9)
          join issuestatus ist on ist.id = j1.issuestatus
          join project pj on j1.project = pj.id and pj.pname = '#{jira_project}'
          join priority pri on pri.id = j1.priority
          join nodeassociation n on n.source_node_id = j1.id
            and n.association_type='IssueFixVersion'
            and n.sink_node_id in (
              select pv.id from projectversion pv
                where pv.project = pj.id
                and (#{version_conditions})
            )
    ;
    "
  end

  def get_project_version_sub_tasks(parent_ids)
    # 11: Dev Sub-Task
    # 12: QA Sub-Task
    # 13: Bug Sub-Task
    # 37: Automation Sub-Task
    "
    select
      j1.id,
      j1.summary,
      ist.pname,
      it.pname,
      pri.pname,
      j1.pkey,
      j1.assignee,
      j1.created,
      j1.updated,
      j1.timeoriginalestimate,
      j1.timeestimate,
      j1.timespent,
      j2.id
        from jiraissue j1
          join issuetype it on it.id = j1.issuetype and it.id in (11, 12, 13, 37)
          join issuestatus ist on ist.id = j1.issuestatus
          join priority pri on pri.id = j1.priority
          join issuelink il on il.destination = j1.id
            and il.linktype = 10000
          join jiraissue j2 on j2.id = il.source
            and j2.id in (#{parent_ids.join(',')})
    ;
    "
  end
end