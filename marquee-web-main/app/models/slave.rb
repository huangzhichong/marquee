# == Schema Information
#
# Table name: slaves
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  ip_address   :string(255)
#  project_name :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  status       :string(255)
#

class Slave < ActiveRecord::Base
  has_one :operation_system_info
  has_many :capabilities
  has_many :slave_assignments
  has_many :automation_script_results, :through => :slave_assignments

  def free!
    self.status = "free"
    save
  end

  def offline!
    self.status = "offline"
    save
  end
end
