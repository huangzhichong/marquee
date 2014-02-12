# == Schema Information
#
# Table name: automation_script_results
#
#  id                   :integer         not null, primary key
#  state                :string(255)
#  pass                 :integer
#  failed               :integer
#  warning              :integer
#  not_run              :integer
#  result               :string(255)
#  start_time           :datetime
#  end_time             :datetime
#  test_round_id        :integer
#  automation_script_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class AutomationScriptResult < ActiveRecord::Base
  include CounterUpdatable
  belongs_to :test_round
  belongs_to :automation_script
  has_many :automation_case_results
  has_many :target_services
  has_many :slave_assignments
  has_many :slaves, :through => :slave_assignments

  delegate :name, :to => :automation_script, :prefix => false

  def find_case_result_by_case_id(case_id)
    self.automation_case_results.find_by_automation_case_id(case_id)
  end

  def set_default_values
    self.state = "scheduling"
    self.pass = 0
    self.failed = 0
    self.warning = 0
    self.not_run = 0
    self.result = 'pending'
    self.triage_result = 'N/A'
  end

  def self.create_from_test_round_and_automation_script(test_round, automation_script)
    asr = AutomationScriptResult.new
    asr.set_default_values
    asr.test_round = test_round
    asr.automation_script = automation_script

    asr.not_run = automation_script.automation_cases.count
    asr.save

    automation_script.automation_cases.each do |ac|
      AutomationCaseResult.create_from_automation_script_result_and_automation_case(asr, ac)
    end

    asr
  end

  def clear
    self.automation_case_results.each do |acr|
      acr.delete
    end
    self.automation_script.automation_cases.each do |ac|
      AutomationCaseResult.create_from_automation_script_result_and_automation_case(self,ac)
    end
    self.set_default_values
    self.not_run = automation_script.automation_cases.count
    self.start_time = nil
    self.end_time = nil
    self.save
    self.test_round.clear
  end

  def passed?
    self.result == "pass"
  end

  def end?
  self.state == 'done' or self.state == 'killed' or self.state == 'failed' or self.state == 'timeout' or self.state == 'not implemented' or self.state == 'network issue'
end

def not_run_cases
  self.automation_case_results.where(:result => "not-run")
end

def failed_cases
  self.automation_case_results.where(:result => "failed")
end

def update_state!(state)
  counter_automation_script_and_test_round_result(state)
  self.state = state
  if state == "running"
    self.start_time = Time.now if self.start_time.blank?
  elsif state == "done"
    self.end_time = Time.now
    self.not_run_cases.each do |automation_case_result|
      automation_case_result.result = 'not-run'
      automation_case_result.save
    end
    if self.not_run > 0
      self.result = 'warning'
    else
      self.result = self.failed > 0 ? 'failed' : 'pass'
    end
  else
    self.end_time = Time.now
    self.result = 'failed'
  end
  
  save
end

def update_triage!(triage_result)
  self.triage_result = triage_result
  self.result = "failed" if triage_result == "Product Error"
  self.result = "failed" if triage_result == "Environment Error"
  self.result = "pass" if triage_result == "Script Error"
  save
end

def duration
  if start_time && end_time
    end_time - start_time
  else
    nil
  end
end

  def pass_count
    self.automation_case_results.where("result='pass'").count
  end

  def failed_count
    self.automation_case_results.where("result='failed'").count
  end

  def warning_count
    self.automation_case_results.where("result='warning'").count
  end

  def not_run_count
    self.automation_case_results.where("result='not-run'").count
  end
  
  def counter_automation_script_and_test_round_result(state)
    if state == 'done' || state == 'failed'
      # update script result counting status
      self.pass = pass_count
      self.failed = failed_count
      self.warning = warning_count
      self.not_run = not_run_count
      self.save
      # update test round result counting status
      tr = self.test_round
      tr.pass = tr.pass_count
      tr.failed = tr.failed_count
      tr.warning = tr.warning_count
      tr.not_run = tr.not_run_count
      tr.save
    end
  end
end
