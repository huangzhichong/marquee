require 'secondbase/model'

class FndJiraIssue < SecondBase::Base

  def self.platform
    where('fnd_jira_issues.key like ? or fnd_jira_issues.key like ? or fnd_jira_issues.key like ? or fnd_jira_issues.key like ? or fnd_jira_issues.key like ? or fnd_jira_issues.key like ?', 'FNDAMS%', 'FNDFIND%', 'USER%', 'EMAILZ%', 'COMMERCE%', 'AMOB%')
  end

  def self.ams
    where("fnd_jira_issues.key like 'FNDAMS%'")
  end

  def self.els
    where("fnd_jira_issues.key like 'FNDFIN%'")
  end

  def self.fusaus
    where("fnd_jira_issues.key like 'USER%'")
  end

  def self.email
    where("fnd_jira_issues.key like 'EMAILZ%'")
  end

  def self.commerce
    where("fnd_jira_issues.key like 'COMMERCE%'")
  end

  def self.mobile
    where("fnd_jira_issues.key like 'AMOB%'")
  end

  def self.endurance
    where('fnd_jira_issues.key like ? or fnd_jira_issues.key like ?' , 'FNDENDR%', 'FNDGVNG%')
  end

  def self.camps
    where('fnd_jira_issues.key like ?' , 'FNDCAMP%')
  end

  def self.sports
    where('fnd_jira_issues.key like ?' , 'FNDSPORTS%')
  end

  def self.swimming
    where("fnd_jira_issues.key like 'FNDSWIM%'")
  end

  def self.team_sports
    where("fnd_jira_issues.key like 'FNDSPORTS%'")
  end

  def self.membership
    where("fnd_jira_issues.key like 'MEMB%'")
  end

  def self.framework
    where("fnd_jira_issues.key like 'FRAME%'")
  end

  def self.known_production_issue
    where("fnd_jira_issues.known_production_issue = 'Yes'")
  end

  def self.closed
    where(:status => 'Closed')
  end

  def self.fixed
    where(:resolution => 'Fixed')
  end

  def self.open
    where(:status => 'Open')
  end

  def self.not_closed
    where('fnd_jira_issues.status != ?', 'Closed')
  end

  def self.resolved_today
    where('fnd_jira_issues.jira_resolved > ?', Date.today - 1)
  end

  def self.found_today
    where('fnd_jira_issues.jira_created > ?', Date.today - 1)
  end

  def self.resolved_90_days
    where('fnd_jira_issues.jira_resolved > ?', Date.today - 90)
  end

  def self.found_90_days
    where('fnd_jira_issues.jira_created > ?', Date.today - 90)
  end

  def self.bugs
    where(:issue_type => ['Bug', 'Bug Sub-Task'])
  end

  def self.requirement
    where(:issue_type => "Requirement/ User Story")
  end


  def self.production
    where('fnd_jira_issues.environment_bug_was_found like ?', 'Prod%')
  end

  def self.non_production
    where('fnd_jira_issues.environment_bug_was_found not like ?', 'Prod%')
  end

  def self.external
    where('fnd_jira_issues.who_found like ?', 'External%')
  end

  def self.internal
    where('fnd_jira_issues.who_found like ?', 'Internal%')
  end

  def self.by_severity(severity)
    where(:severity => severity)
  end

  def self.by_priority(priority)
    where(:priority => priority)
  end

  def self.endurance_resolved_bugs_to_date
    endurance.closed.fixed.bugs.resolved_today.count
  end

  def self.camps_resolved_bugs_to_date
    camps.closed.fixed.bugs.resolved_today.count
  end

  def self.sports_resolved_bugs_to_date
    sports.closed.fixed.bugs.resolved_today.count
  end

  def self.platform_resolved_bugs_to_date
    platform.closed.fixed.bugs.resolved_today.count
  end

  def self.total_resolved_bugs_to_date
    closed.fixed.bugs.resolved_today.count
  end

  def self.total_bugs_found_to_date
    bugs.found_today.count
  end

  def self.endurance_bugs_found_to_date
    endurance.bugs.found_today.count
  end

  def self.camps_bugs_found_to_date
    camps.bugs.found_today.count
  end

  def self.sports_bugs_found_to_date
    sports.bugs.found_today.count
  end

  def self.platform_bugs_found_to_date
    platform.bugs.found_today.count
  end

  def self.total_production_bugs_found_to_date
    bugs.production.found_today.count
  end

  def self.endurance_production_bugs_found_to_date
    endurance.bugs.production.found_today.count
  end

  def self.camps_production_bugs_found_to_date
    camps.bugs.production.found_today.count
  end

  def self.sports_production_bugs_found_to_date
    sports.bugs.production.found_today.count
  end

  def self.platform_production_bugs_found_to_date
    platform.bugs.production.found_today.count
  end

  def self.total_non_production_bugs_found_to_date
    bugs.non_production.found_today.count
  end

  def self.endurance_non_production_bugs_found_to_date
    endurance.bugs.non_production.found_90_days.count
  end

  def self.camps_non_production_bugs_found_to_date
    camps.bugs.non_production.found_90_days.count
  end

  def self.sports_non_production_bugs_found_to_date
    sports.bugs.non_production.found_90_days.count
  end

  def self.platform_non_production_bugs_found_to_date
    platform.bugs.non_production.found_90_days.count
  end

  def self.total_external_production_bugs_found_to_date
    bugs.production.external.found_90_days.count
  end

  def self.endurance_external_production_bugs_found_to_date
    endurance.bugs.production.external.found_90_days.count
  end

  def self.camps_external_production_bugs_found_to_date
    camps.bugs.production.external.found_90_days.count
  end

  def self.sports_external_production_bugs_found_to_date
    sports.bugs.production.external.found_90_days.count
  end

  def self.platform_external_production_bugs_found_to_date
    platform.bugs.production.external.found_90_days.count
  end

  def self.total_internal_production_bugs_found_to_date
    bugs.production.internal.found_90_days.count
  end

  def self.endurance_internal_production_bugs_found_to_date
    endurance.bugs.production.internal.found_90_days.count
  end

  def self.camps_internal_production_bugs_found_to_date
    camps.bugs.production.internal.found_90_days.count
  end

  def self.sports_internal_production_bugs_found_to_date
    sports.bugs.production.internal.found_90_days.count
  end

  def self.platform_internal_production_bugs_found_to_date
    platform.bugs.production.internal.found_90_days.count
  end

  def self.format_dre(dre)
    dre = dre.nan? ? 0.0 : dre
    format('%.2f', dre)
  end

  def self.overall_dre
    dre = (((bugs.production.external.found_90_days.count.to_f -
            bugs.production.external.found_90_days.duplicate.count.to_f -
            bugs.production.external.found_90_days.not_a_bug.count.to_f -
            bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.endurance_dre
    dre = (((endurance.bugs.production.external.found_90_days.count.to_f -
            endurance.bugs.production.external.found_90_days.duplicate.count.to_f -
            endurance.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            endurance.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            endurance.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.camps_dre
    dre = (((camps.bugs.production.external.found_90_days.count.to_f -
            camps.bugs.production.external.found_90_days.duplicate.count.to_f -
            camps.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            camps.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            camps.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.sports_dre
    dre = (((sports.bugs.production.external.found_90_days.count.to_f -
            sports.bugs.production.external.found_90_days.duplicate.count.to_f -
            sports.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            sports.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            sports.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.swimming_dre
    dre = (((swimming.bugs.production.external.found_90_days.count.to_f -
            swimming.bugs.production.external.found_90_days.duplicate.count.to_f -
            swimming.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            swimming.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            swimming.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.membership_dre
    dre = (((membership.bugs.production.external.found_90_days.count.to_f -
            membership.membership.membership.bugs.production.external.found_90_days.duplicate.count.to_f -
            membership.membership.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            membership.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            membership.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.platform_dre
    dre = (((platform.bugs.production.external.found_90_days.count.to_f -
            platform.bugs.production.external.found_90_days.duplicate.count.to_f -
            platform.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            platform.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            platform.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.framework_dre
    dre = (((framework.bugs.production.external.found_90_days.count.to_f -
            framework.bugs.production.external.found_90_days.duplicate.count.to_f -
            framework.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            framework.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            framework.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.ams_dre
    dre = (((ams.bugs.production.external.found_90_days.count.to_f -
            ams.bugs.production.external.found_90_days.duplicate.count.to_f -
            ams.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            ams.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            ams.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.mobile_dre
    dre = (((mobile.bugs.production.external.found_90_days.count.to_f -
            mobile.bugs.production.external.found_90_days.duplicate.count.to_f -
            mobile.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            mobile.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            mobile.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.els_dre
    dre = (((els.bugs.production.external.found_90_days.count.to_f -
            els.bugs.production.external.found_90_days.duplicate.count.to_f -
            els.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            els.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            els.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.email_dre
    dre = (((email.bugs.production.external.found_90_days.count.to_f -
            email.bugs.production.external.found_90_days.duplicate.count.to_f -
            email.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            email.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            email.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.commerce_dre
    dre = (((commerce.bugs.production.external.found_90_days.count.to_f -
            commerce.bugs.production.external.found_90_days.duplicate.count.to_f -
            commerce.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            commerce.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            commerce.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.fusaus_dre
    dre = (((fusaus.bugs.production.external.found_90_days.count.to_f -
            fusaus.bugs.production.external.found_90_days.duplicate.count.to_f -
            fusaus.bugs.production.external.found_90_days.not_a_bug.count.to_f -
            fusaus.bugs.production.external.found_90_days.cannot_reproduce.count.to_f) /
            fusaus.bugs.found_90_days.count.to_f) * 100).round(2)
    self.format_dre(dre)
  end

  def self.bugs_by_severity(severity)
    where(:severity => severity)
  end

  def self.duplicate
    where(:resolution => 'Duplicate')
  end

  def self.not_a_bug
    where(:resolution => 'Not a Bug')
  end

  def self.cannot_reproduce
    where(:resolution => 'Cannot Reproduce')
  end

  # technical debt
  def self.camps_technical_debt_by_priority(priority)
    dre = camps.bugs.open.non_production.known_production_issue.by_priority(priority).count.to_f*100 / camps.bugs.open.by_priority(priority).count.to_f
    self.format_dre(dre)
  end

  def self.endurance_technical_debt_by_priority(priority)
    dre = endurance.bugs.open.non_production.known_production_issue.by_priority(priority).count.to_f*100 / endurance.bugs.open.by_priority(priority).count.to_f
    self.format_dre(dre)
  end

  def self.sports_technical_debt_by_priority(priority)
    dre = sports.bugs.open.non_production.known_production_issue.by_priority(priority).count.to_f*100 / sports.bugs.open.by_priority(priority).count.to_f
    self.format_dre(dre)
  end

  def self.swimming_technical_debt_by_priority(priority)
    dre = swimming.bugs.open.non_production.known_production_issue.by_priority(priority).count.to_f*100 / swimming.bugs.open.by_priority(priority).count.to_f
    self.format_dre(dre)
  end

  def self.membership_technical_debt_by_priority(priority)
    dre = membership.bugs.open.non_production.known_production_issue.by_priority(priority).count.to_f*100 / membership.bugs.open.by_priority(priority).count.to_f
    self.format_dre(dre)
  end

  def self.framework_technical_debt_by_priority(priority)
    dre = framework.bugs.open.non_production.known_production_issue.by_priority(priority).count.to_f*100 / framework.bugs.open.by_priority(priority).count.to_f
    self.format_dre(dre)
  end

  def self.platform_technical_debt_by_priority(priority)
    dre = platform.bugs.open.non_production.known_production_issue.by_priority(priority).count.to_f*100 / platform.bugs.open.by_priority(priority).count.to_f
    self.format_dre(dre)
  end

end
