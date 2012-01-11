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
end
