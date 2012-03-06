# == Schema Information
#
# Table name: test_rounds
#
#  id                  :integer         not null, primary key
#  start_time          :datetime
#  end_time            :datetime
#  state               :string(255)
#  result              :string(255)
#  test_object         :string(255)
#  pass                :integer
#  warning             :integer
#  failed              :integer
#  not_run             :integer
#  pass_rate           :float
#  duration            :integer
#  triage_result       :string(255)
#  test_environment_id :integer
#  project_id          :integer
#  creator_id          :integer
#  test_suite_id       :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class TestRound < ActiveRecord::Base
  include CounterUpdatable
  belongs_to :test_environment
  belongs_to :browser
  belongs_to :operation_system
  belongs_to :project
  belongs_to :test_suite
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  has_many :automation_script_results

  delegate :automation_case_count, :to => :test_suite, :prefix => false
  delegate :test_type, :to => :test_suite, :prefix => false

  acts_as_audited :protect => false
  # acts_as_audited :protect => false, :only => [:create, :destroy]

  validates_presence_of :test_object

  def to_s
    "#{self.test_type.name} ##{self.id}"
  end

  def find_automation_scirpt_by_script_name(script_name)
    self.test_suite.automation_scripts.find_by_name(script_name)
  end

  def set_default_value
    self.state = "scheduling"
    self.result = 'pending'
    self.pass = 0
    self.warning = 0
    self.failed = 0
    self.not_run = 0
  end

  def clear
    self.end_time = nil
    self.state = "scheduling"
    self.result = "pending"
    self.duration = nil
    self.pass = pass_count
    self.failed = failed_count
    self.warning = warning_count
    self.not_run = not_run_count
    calculate_pass_rate!
    self.save
  end

  def self.create_for_new_build(test_suite, project, test_environment, user, test_object)
    test_round = TestRound.new
    test_round.set_default_value
    test_round.test_suite = test_suite
    test_round.creator = user
    test_round.project = project
    test_round.test_object = test_object
    test_round.test_environment = test_environment
    test_round.init_automation_script_result
    test_round.save
    test_round
  end

  def init_automation_script_result
    test_suite.automation_scripts.each do |as|
      AutomationScriptResult.create_from_test_round_and_automation_script(self, as)
    end
    self.not_run = not_run_count
    save
  end

  def end?
    ["not implemented","service error","completed"].include? self.state
  end

  def fail?
    result == 'failed'
  end

  def all_automation_script_results_finished?
    automation_script_results.all?{|asr| asr.end?}
  end

  def update_start_time
    self.start_time = self.automation_script_results.collect{|asr| asr.start_time.nil? ? Time.now : asr.start_time}.min
  end

  def start_running!
    unless running?
      self.state = 'running'
      # update_start_time
    end
  end

  def end_running!
    if running?
      calculate_result!
      self.end_time = Time.now
      calculate_duration!
      calculate_pass_rate!
      calculate_result!
    end
  end

  def scheduling?
    self.state == "scheduling"
  end

  def running?
    self.state == "running"
  end

  def calculate_result!
    if automation_script_results.all?{|asr| asr.automation_script.not_implemented? }
      self.state = 'not implemented'
      self.result = 'N/A'
    # elsif automation_script_results.all?{|asr| asr.service_error?}
      # self.state = 'service error'
      # self.result = 'N/A'
    elsif automation_script_results.all?{|asr| asr.passed?}
      self.state = 'completed'
      self.result = 'pass'
    else
      self.state = 'completed'
      self.result = 'failed'
    end
  end

  def calculate_duration!
    self.duration = end_time - start_time
  end

  def pass_count
    self.automation_script_results.sum(:pass)
  end

  def failed_count
    self.automation_script_results.sum(:failed)
  end

  def warning_count
    self.automation_script_results.sum(:warning)
  end

  def not_run_count
    self.automation_script_results.sum(:not_run)
  end

  def calculate_pass_rate!
    if automation_case_count == 0
      0.0
    else
      self.pass_rate = (pass_count.to_f * 100)/ automation_case_count
      self.pass_rate.round(2)
    end
  end

  def update_state!
    if all_automation_script_results_finished?
      end_running!
    else
      start_running!
    end
    save
  end

  def send_triage_mail?
    self.automation_script_results.any?{|asr| asr.result != 'pass' and asr.triage_result == "N/A"}
  end

  def update_result
    if automation_script_results.any?{|asr| asr.triage_result == "Product Error"}
      self.result = 'failed'
    else
      self.result = 'pass'
    end
    save
  end

  def find_automation_script_result_by_script_name(script_name)
    automation_script = self.test_suite.automation_scripts.find_last_by_name(script_name)
    self.automation_script_results.find_last_by_automation_script_id(automation_script.id)
  end

end
