class Report::JiraIssue
  include Mongoid::Document

  field :key, type: String
  field :jira_id, type: String
  field :issue_type, type: String
  field :issue_status, type: String
  field :original_estimation, type: Integer

  embeds_many :work_logs, class_name: "Report::WorkLog"
  embeds_many :change_items, class_name: "Report::JiraChangeItem"
  has_and_belongs_to_many :sub_tasks, class_name: "Report::JiraIssue"

  def self.all_effort()
    requirements = Report::JiraIssue.where(issue_type: "Requirement")
    (requirements.collect{|req| req.total_work_done}.inject(0){|sum, work_done| sum += work_done} / 3600.0).round(0)
  end

  def self.all_effort_at(date, issue_type)
    requirements = Report::JiraIssue.where(issue_type: "Requirement")
    (requirements.collect{|req| req.work_done_by_date_and_category(date, issue_type)}.inject(0){|sum, work_done| sum += work_done} / 3600.0).round(0)
  end

  def total_estimation
    self.sub_tasks.inject(0){|sum, sub_task| sum += sub_task.original_estimation}
  end

  def total_work_done
    self.sub_tasks.inject(0){|sum, sub_task| sum += sub_task.work_logs.inject(0){|wl| sum += wl.time_worked} }
  end

  def estimation_by_issue_type(issue_type)
    self.sub_tasks.where(issue_type: issue_type).inject(0){|sum, subtask| sum += subtask.original_estimation}
  end

  def sub_tasks_count_by_category(category)
    self.sub_tasks.where(issue_type: category).count
  end

  def sub_tasks_done_by_date_and_category(day, category)
    self.sub_tasks.to_a.count{|sub_task| sub_task.issue_type == category && day >= sub_task.close_date}
  end

  def work_done_by_date(day)
    self.work_logs.where(start_date: day).inject(0){|sum, wl| sum += wl.time_worked}
  end

  def work_done_by_date_and_category(day, category)
    candidates = self.work_logs.where(start_date: day) & self.work_logs.where(category: category)
    # logger.info "----#{candidates.inspect}" if candidates.count > 0
    candidates.inject(0){|sum, wl| sum += wl.time_worked}
  end

  def closed_at?(date)
    change_item = self.change_items.where(new_string: 'Closed').first
    if change_item.nil?
      false
    else
      date >= change_item.change_date.to_date
    end
  end

  def close_date
    ci = self.change_items.where(new_string: 'Closed').first
    if ci.nil?
      Date.today + 1000
    else
      ci.change_date.to_date
    end
  end

  def status_at_date(date)
    range = self.change_items.sort_by{|ci| ci.change_date}.reverse

    change_item = range.select{|r| date >= r.change_date}.first

    if change_item.nil?
      'open'
    else
      change_item.new_string.downcase.parameterize
    end
  end

  def status_change_chronicle
    change_items.sort_by{|ci| ci.change_date}
  end
end