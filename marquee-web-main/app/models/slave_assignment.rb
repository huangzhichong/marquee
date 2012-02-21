# == Schema Information
#
# Table name: slave_assignments
#
#  id                          :integer         not null, primary key
#  automation_script_result_id :integer
#  slave_id                    :integer
#  status                      :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  driver                      :string(255)
#

class SlaveAssignment < ActiveRecord::Base
  default_scope :include => [:automation_script_result]
  belongs_to :automation_script_result
  belongs_to :slave

  acts_as_audited :protect => false

  def automation_script
    automation_script_result.automation_script
  end

  def test_round
    automation_script_result.test_round
  end

  def end!
    self.status = "complete"
    save
  end

  def reset!
    self.status = "pending"
    self.slave_id = nil
    self.created_at = Time.now
    self.updated_at = Time.now
  end

  def automation_driver_config
    AutomationDriverConfig.find(:first, :conditions => ['project_id = ? AND automation_driver_id = ?', self.test_round.project.id, self.automation_script.automation_driver.id])
  end

  def as_json(options={})
    {
      id: self.id,
      project: self.test_round.project.name,
      slave_id: self.slave.nil? ? nil : self.slave.id,
      time_out_limit: self.automation_script.time_out_limit.nil? ? AutomationScript::DEFAULT_TIME_OUT_LIMIT : self.automation_script.time_out_limit,
      test_round_id: self.test_round.id,
      script_name: self.automation_script.name,
      test_environment: self.test_round.test_environment.value,
      test_type: self.test_round.test_suite.test_type.name,
      automation_driver: self.automation_script.automation_driver.as_json,
      script_main_path: self.automation_script.script_main_path,
      automation_driver_config: self.automation_driver_config.as_json
    }
  end

end
