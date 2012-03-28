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

  validates_presence_of :name, :ip_address, :project_name, :test_type, :priority, :active
  validates_uniqueness_of :name, :ip_address, :message => " already exists."

  def free!
    self.status = "free"
    save
  end

  def offline!
    self.status = "offline"
    save
  end
end
