class ExperimentController < ApplicationController
  include JiraQueries
  layout 'experiment'

  def effort_analysis_report
    redirect_to experiment_ear_path
  end

  def effort_tracking
    @project = "Endurance"
    @jira_project = "FNDENDR"
    @group = 'AW Endurance'
    @start_date = Date.today - 2
    @end_date = Date.today
    @release_version = 'Release 2.9'
  end

  def effort_tracking_report
    @project_name = params[:project]
    @jira_project = params[:jira_project]
    @release_version = params[:release_version]
    @group = params[:group]
    @start_date = Date.new(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
    @end_date = Date.new(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i)
    logger.info { "#{@start_date} - #{@end_date}" }

    @tracking = Report::Tracking.where('$and' => [{'project' => @project_name}, {'jira_group' => @group},
     {'release_version' => @release_version}]).first

    if @tracking.nil?
      @tracking = Report::Tracking.create({
        project: @project_name,
        jira_project: @jira_project,
        jira_group: @group,
        start_date: @start_date,
        end_date: @end_date,
        release_version: @release_version
      })
    end

    @record = @tracking.records.last

    pull_data unless (@record != nil and @record.generated_at.to_date == Date.today)

    @record = @tracking.records.last
    @total_effort = (@record.total_time_worked / 3600.0).round()
    @in_release_effort = (@record.in_release_time_worked / 3600.0).round()
    @out_release_effort = (@record.out_of_release_time_worked / 3600.0).round()
    @other_proj_effort = (@record.out_of_project_time_worked / 3600.0).round()

    @detail_effort_distribution_data = [
      @tracking.time_spent_on_new_features/3600.0,
      @tracking.time_spent_on_bug_sub_tasks/3600.0,
      @tracking.time_spent_on_bugs/3600.0,
      @tracking.time_spent_on_production_support/3600.0,
      @tracking.time_spent_on_environment_issues/3600.0,
      @tracking.time_spent_on_pto/3600.0,
      @tracking.time_spent_on_general_support/3600.0,
      @tracking.time_spent_on_anlysis_and_design/3600.0
    ]

    @detail_effort_distribution_labels = [
      "#{(@tracking.time_spent_on_new_features / 3600.0).round()} on New Features",
      "#{(@tracking.time_spent_on_bug_sub_tasks / 3600.0).round()} on Bug Sub-Tasks",
      "#{(@tracking.time_spent_on_bugs / 3600.0).round()} on Bugs",
      "#{(@tracking.time_spent_on_production_support / 3600.0).round()} on Production Support",
      "#{(@tracking.time_spent_on_environment_issues / 3600.0).round()} on Environment Issues",
      "#{(@tracking.time_spent_on_pto / 3600.0).round()} on PTO",
      "#{(@tracking.time_spent_on_general_support / 3600.0).round()} on General Support",
      "#{(@tracking.time_spent_on_anlysis_and_design / 3600.0).round()} on Anlysis&Design"
    ]

    @open_bugs_count_by_priority = [
      @record.p0_open_bugs_count,
      @record.p1_open_bugs_count,
      @record.p2_open_bugs_count,
      @record.p3_open_bugs_count,
      @record.p4_open_bugs_count,
    ]

    a = []
    @record.daily_open_bugs_count_string.split(';').inject(a){|a, s| a << s.split('|')[1]}
    @open_bugs_count_by_day = a

    b = []
    @record.daily_open_bugs_count_string.split(';').inject(b){|a, s| a << s.split('|')[0]}
    @open_bugs_count_by_day_labels = b
  end

  def ear
    @config = Report::VersionTrackingConfig.last
    @dev_effort = @config.total_effort_by_issue_types(['Dev Sub-Task', 'Dev Task', 'Bug Sub-Task', 'Bug'])
    @qa_effort = @config.total_effort_by_issue_types(['QA Sub-Task', 'QA Task'])
    @requirements_done = @config.requirements_done
    @dev_activities = []
    @qa_activities = []
    @bug_activities = []
    @config.start_date.upto(@config.end_date).each do |day|
      next if day.saturday? or day.sunday?
      @dev_activities << @config.effort_by_day_and_issue_types(day, ['Dev Sub-Task', 'Dev Task'])
      @qa_activities << @config.effort_by_day_and_issue_types(day, ['QA Sub-Task', 'QA Task'])
      @bug_activities << @config.effort_by_day_and_issue_types(day, ['Bug Sub-Task', 'Bug'])
    end
    @project = @config.jira_project
    @sample_data = [
      {
        :key => 'FNDCAMP-8088',
        :duration => 18,
        :design => 5,
        :coding => 8,
        :testing => 5
      },
      {
        :key => 'FNDCAMP-8087',
        :duration => 12,
        :design => 3,
        :coding => 10,
        :testing => 1
      },
      {
        :key => 'FNDCAMP-8087',
        :duration => 12,
        :design => 5,
        :coding => 13,
        :testing => 1
      },
      {
        :key => 'FNDCAMP-8087',
        :duration => 12,
        :design => 3,
        :coding => 7,
        :testing => 3
      },
      {
        :key => 'FNDCAMP-8087',
        :duration => 12,
        :design => 2,
        :coding => 8,
        :testing => 8
      }
    ]
    @requirement_titles = []
    @requirement_bugs = []
    @requirement_bug_links = []
    @config.issues.where(issue_type: 'Requirement/ User Story').each do |req|
      @requirement_titles << "#{req.key}: ## / %%"
      @requirement_bugs << req.bug_count
      @requirement_bug_links << "http://jirafnd.dev.activenetwork.com/browse/#{req.key}"
    end

    @most_buggy_requirement = @config.issues.where(issue_type: 'Requirement/ User Story').sort{|x, y| y.bug_count <=> x.bug_count}.first

    @bugs_by_priority = @config.total_bugs_by_priority
  end

  protected
  def pull_data
    record = @tracking.records.build
    record.total_time_worked = FndJira.connection.execute(get_work_done_in_total_by_group_and_date_range(@group, @start_date, @end_date)).first[0]
    record.out_of_release_time_worked = FndJira.connection.execute(get_work_done_out_of_version_by_group_and_date_range_and_version(@group, @start_date, @end_date, @project_name, @release_version)).first[0]
    record.out_of_project_time_worked = FndJira.connection.execute(get_work_done_out_of_project_by_group_and_date_range(@group, @start_date, @end_date, @project_name)).first[0]
    
    (record.out_of_project_time_worked = 0)  if record.out_of_project_time_worked.nil?
    (record.total_time_worked = 0) if record.total_time_worked.nil?
    (record.out_of_release_time_worked = 0) if record.out_of_release_time_worked.nil?
    
    record.in_release_time_worked = record.total_time_worked - record.out_of_release_time_worked - record.out_of_project_time_worked

    record.generated_at = DateTime.now
    record.save

    results = FndJira.connection.execute(get_work_logs_by_group_and_date_range(@group, @start_date, @end_date, @release_version))
    
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
      work_log = @tracking.work_logs.where(jira_id: result[0].to_i.to_s).first
      work_log = @tracking.work_logs.build() if work_log.nil?
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

      jira_issue = Report::JiraIssue.find_or_create_by(key: result[5])
      jira_issue.issue_type = result[6]
      jira_issue.jira_id = result[2].to_i.to_s
      jira_issue.save
    end

    total_open_bugs_count = FndJira.connection.execute(get_total_open_bugs_count(@jira_project)).first[0]
    open_bugs_count_by_priority = FndJira.connection.execute(get_open_bugs_count_by_priority(@jira_project))

    record.p0_open_bugs_count = 0
    record.p1_open_bugs_count = 0
    record.p2_open_bugs_count = 0
    record.p3_open_bugs_count = 0
    record.p4_open_bugs_count = 0

    open_bugs_count_by_priority.each do |result|
      logger.info { "#{result[0]} - #{result[1]}" }
      case result[0].to_i
      when 1
        record.p0_open_bugs_count = result[1]
      when 2
        record.p1_open_bugs_count = result[1]
      when 3
        record.p2_open_bugs_count = result[1]
      when 4
        record.p3_open_bugs_count = result[1]  
      when 5
        record.p4_open_bugs_count = result[1]
      end
    end

    tmp = ""
    (@start_date .. Date.today).each do |day|
      tmp += day.to_date.to_s
      tmp += '|'
      tmp += FndJira.connection.execute(get_bugs_created_by_day(@jira_project, day)).first[0].to_i.to_s
      tmp += ';'
    end
    
    record.daily_open_bugs_count_string = tmp

    record.save
  end
end