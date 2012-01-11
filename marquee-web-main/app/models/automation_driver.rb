# == Schema Information
#
# Table name: automation_drivers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class AutomationDriver < ActiveRecord::Base
  has_many :automation_scripts
  
  def to_s
    self.name
  end
end
