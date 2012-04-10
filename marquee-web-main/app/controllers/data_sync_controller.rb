require File.expand_path('../../helpers/jira_data_sync', __FILE__)
require File.expand_path('../../helpers/sync_time_card_file', __FILE__)

class DataSyncController < ApplicationController

  include FndJiraQueries
  
  def fnd_jira
    if request.remote_ip != '127.0.0.1'
      render :text => "Not allowed to generate from anywhere other than the server itself."
      return
    end
    JiraDataSync.createJob
    render :nothing => true
  end

  def time_card
    if request.remote_ip != '127.0.0.1'
      render :text => "Not allowed to generate from anywhere other than the server itself."
      return
    end
    SyncTimeCardFile.createJob
    render :nothing => true
  end

  def regenerate_dre
    if request.remote_ip != '127.0.0.1'
      render :text => "Not allowed to generate from anywhere other than the server itself."
      return
    end
    import_fnd_data_from_jira_mirror
  end
  private
  def import_fnd_jira_query_result_into_db(result)
    if Rails.env == 'development'
      result.each do |r|
        FndJiraIssue.create(:key => r[0],
                         :status => r[1],
                         :resolution => r[2],
                         :jira_created => r[3],
                         :jira_resolved => r[4],
                         :priority => r[5],
                         :severity => r[6],
                         :issue_type => r[7],
                         :environment_bug_was_found => r[8],
                         :who_found => r[9],
                         :market => r[10],
                         :planning_estimate_level_two => r[11],
                         :known_production_issue => r[12])
      end
    else
      data = []

      result.each do |r|
        key = r[0].nil? ? nil : r[0].gsub("'", "''")
        status = r[1].nil? ? nil : r[1].gsub("'", "''")
        resolution = r[2].nil? ? nil : r[2].gsub("'", "''")
        jira_created = r[3]
        jira_resolved = r[4]
        priority = r[5].nil? ? nil : r[5].gsub("'", "''")
        severity = r[6].nil? ? nil : r[6].gsub("'", "''")
        issue_type = r[7].nil? ? nil : r[7].gsub("'", "''")
        environment_bug_was_found = r[8].nil? ? nil : r[8].gsub("'", "''")
        who_found = r[9].nil? ? nil : r[9].gsub("'", "''")
        market = r[10].nil? ? nil : r[10].gsub("'", "''")
        planning_estimate_level_two = r[11].nil? ? nil : r[11].to_i
        known_production_issue = r[12].nil? ? nil : r[12].gsub("'", "''")


        data << "('#{key}', '#{status}', '#{resolution}', '#{jira_created}', '#{jira_resolved}', '#{priority}', '#{severity}', '#{issue_type}', '#{environment_bug_was_found}', '#{who_found}', '#{market}', '#{planning_estimate_level_two}', '#{known_production_issue}')"
      end

      sql = "INSERT INTO fnd_jira_issues (`key`, `status`, `resolution`, `jira_created`, `jira_resolved`, `priority`, `severity`, `issue_type`, `environment_bug_was_found`, `who_found`, `market`, `planning_estimate_level_two`, `known_production_issue`) VALUES #{data.join(", ")}"

      ActiveRecord::Base.connection.execute sql
    end
  end

  def import_fnd_data_from_jira_mirror
    FndJiraIssue.delete_all
    result = FndJiraIssue.connection.execute(all_projects_bugs_query_string)
    import_fnd_jira_query_result_into_db(result)

    result2 = FndJiraIssue.connection.execute(all_closed_requirements_query_string)
    import_fnd_jira_query_result_into_db(result2)

    result3 = FndJiraIssue.connection.execute(framework_bugs_with_specified_components_query_string)
    import_fnd_jira_query_result_into_db(result3)

    result4 = FndJiraIssue.connection.execute(team_sports_bugs_with_specified_components_query_string)
    import_fnd_jira_query_result_into_db(result4)

    today = Date.today
    today_str = "#{today.month}/#{today.day}/#{today.year.to_s[2, 2]}"

    # update dre
    %w(Overall Endurance Camps Sports Swimming Membership Platform Framework).each do |project|
      p = Report::Project.where(name: project).first
      p = Report::Project.create(name: project) if p.nil?
      dre = p.dres.where(date: Date.today).first.nil? ? p.dres.build() : p.dres.where(date: Date.today).first
      dre.date = Date.today
      dre.value = FndJiraIssue.send(project.downcase + '_dre')
      dre.save
    end

    # drills down dre for platform components
    %w(Ams Els Mobile Commerce Email FusAus).each do |component|
      p = Report::Project.where(name: component).first
      p = Report::Project.create(name: component) if p.nil?
      dre = p.dres.where(date: Date.today).first.nil? ? p.dres.build() : p.dres.where(date: Date.today).first
      dre.date = Date.today
      dre.value = FndJiraIssue.send(component.downcase + '_dre')
      dre.save
    end

    %w(Endurance Camps Sports Swimming Membership Platform Framework).each do |project|
      p = Report::Project.where(name: project).first
      bugs = p.bugs_by_severities.where(date: Date.today).first.nil? ? p.bugs_by_severities.build() : p.bugs_by_severities.where(date: Date.today).first
      bugs.date = Date.today
      bugs.severity_1 = (FndJiraIssue.send project.downcase).bugs.production.not_closed.by_severity('Sev1').count.to_s
      bugs.severity_2 = (FndJiraIssue.send project.downcase).bugs.production.not_closed.by_severity('Sev2').count.to_s
      bugs.severity_3 = (FndJiraIssue.send project.downcase).bugs.production.not_closed.by_severity('Sev3').count.to_s
      bugs.severity_nyd = (FndJiraIssue.send project.downcase).bugs.production.not_closed.by_severity('Sev-NYD').count.to_s
      bugs.save
    end

    %w(Endurance Camps Sports Swimming Membership Platform Framework).each do |project|
      p = Report::Project.where(name: project).first
      bugs = p.bugs_by_who_founds.where(date: Date.today).first.nil? ? p.bugs_by_who_founds.build() : p.bugs_by_who_founds.where(date: Date.today).first
      bugs.date = Date.today
      bugs.external = (FndJiraIssue.send project.downcase).bugs.production.open.external.count.to_s
      bugs.internal = (FndJiraIssue.send project.downcase).bugs.production.open.internal.count.to_s
      bugs.closed_requirements = (FndJiraIssue.send project.downcase).requirement.closed.count.to_s
      bugs.save
    end

    %w(Endurance Camps Sports Swimming Membership Platform Framework).each do |project|
      p = Report::Project.where(name: project).first
      debt = p.technical_debts.where(date: Date.today).first.nil? ? p.technical_debts.build() : p.technical_debts.where(date: Date.today).first
      debt.date = Date.today
      debt.priority_0 = FndJiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P0').to_s
      debt.priority_1 = FndJiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P1').to_s
      debt.priority_2 = FndJiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P2').to_s
      debt.priority_3 = FndJiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P3').to_s
      debt.priority_4 = FndJiraIssue.send(project.downcase + '_technical_debt_by_priority', 'P4').to_s
      debt.save
    end

    p = Report::Project.where(name: 'Overall').first
    bugs = p.external_bugs_found_by_days.where(date: Date.today).first.nil? ? p.external_bugs_found_by_days.build() : p.external_bugs_found_by_days.where(date: Date.today).first
    bugs.date = Date.today
    bugs.severity_1 = FndJiraIssue.bugs.production.found_today.external.by_severity('Sev1').count.to_s
    bugs.severity_2 = FndJiraIssue.bugs.production.found_today.external.by_severity('Sev2').count.to_s
    bugs.save

    bugs = p.external_bugs_by_day_alls.where(date: Date.today).first.nil? ? p.external_bugs_by_day_alls.build() : p.external_bugs_by_day_alls.where(date: Date.today).first
    bugs.date = Date.today
    bugs.endurance = FndJiraIssue.endurance.bugs.production.external.found_today.count.to_s
    bugs.camps = FndJiraIssue.camps.bugs.production.external.found_today.count.to_s
    bugs.sports = FndJiraIssue.sports.bugs.production.external.found_today.count.to_s
    bugs.swimming = FndJiraIssue.swimming.bugs.production.external.found_today.count.to_s
    bugs.membership = FndJiraIssue.membership.bugs.production.external.found_today.count.to_s
    bugs.platform = FndJiraIssue.platform.bugs.production.external.found_today.count.to_s
    bugs.framework = FndJiraIssue.framework.bugs.production.external.found_today.count.to_s
    bugs.save

    render :text => "Successed"
  end
end

