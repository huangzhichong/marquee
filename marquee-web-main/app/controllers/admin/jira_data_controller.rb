class Admin::JiraDataController < ApplicationController
  include JiraQueries # definition of Fnd Jira Query strings
  before_filter :authenticate_user!
  layout 'no_sidebar'

  def effort_analysis
    # pull_data
    @start_date = Date.parse("21/9/2011")
    @requirements = Report::JiraIssue.all
  end

  def issue_status_chronicle
    key = params[:key]
    @jira_issue = Report::JiraIssue.where(key: key).first
  end

  private
  def pull_data
   pull_jira_issues
   pull_change_items
   pull_work_logs   
  end

  def pull_jira_issues
    sprints = ['Sprint 41 - Gold', 'Sprint 41 - Purple']
    result = FndJira.connection.execute(get_requirement_level_of_original_estimation_query_string(sprints))
    result.each do |r|
      req = Report::JiraIssue.find_or_create_by(key: r[0])

      req.jira_id = r[6].to_i
      req.issue_type = 'Requirement'
      req.issue_status = r[4]
      
      subtask = Report::JiraIssue.first(conditions: {key: r[1]})
      subtask = req.sub_tasks.build() if subtask.nil?
      
      subtask.key = r[1]
      subtask.jira_id = r[7].to_i
      subtask.issue_type = r[3]
      subtask.issue_status = r[5]
      subtask.original_estimation = r[2].to_i
      
      subtask.save
      req.save
    end
  end

  def pull_change_items
    jira_issues = Report::JiraIssue.all.collect{|ji| ji.jira_id}

    result = FndJira.connection.execute(get_change_items_for(jira_issues))
    result.each do |r|
      jira_issue = Report::JiraIssue.where(jira_id: r[8].to_i).first
      if jira_issue.nil?
        logger.info { "------Found a changeitem with no jira issue in the db-- jira id: #{r[8].to_i}------" }
        next
      end

      ci = jira_issue.change_items.where(jira_id: r[0].to_i).first
      ci = jira_issue.change_items.build() if ci.nil?

      ci.jira_id = r[0].to_i
      ci.jira_field = r[1]
      ci.old_value = r[2]
      ci.new_value = r[3]
      ci.old_string = r[4]
      ci.new_string = r[5]
      ci.author = r[6]
      ci.change_date = r[7]

      ci.save
      jira_issue.save
    end
  end

  def pull_work_logs
    sprints = ['Sprint 41 - Gold', 'Sprint 41 - Purple']
    result = FndJira.connection.execute(get_work_log_by_sprints_query_string(sprints))
    result.each do |r|
      jira_issue = Report::JiraIssue.where(key: r[0]).first
      if jira_issue.nil?
        logger.info { "Found a Requirement missing: #{r[0]}" }
        next
      end

      work_log = jira_issue.work_logs.where(jira_id: r[7]).first
      work_log = jira_issue.work_logs.build if work_log.nil?

      work_log.jira_id = r[7]
      work_log.category = r[5]
      work_log.sub_task_key = r[1]
      work_log.start_date = r[2]
      work_log.enter_date = r[3]
      work_log.worker = r[4]
      work_log.time_worked = r[6].to_i

      work_log.save
      jira_issue.save
    end
  end

end