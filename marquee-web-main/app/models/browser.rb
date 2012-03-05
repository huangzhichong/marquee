# == Schema Information
#
# Table name: browsers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  version    :string(255)
#  machine_id :integer
#  allowed    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Browser < ActiveRecord::Base
  belongs_to :machine
  validates_presence_of :name
  validates_presence_of :version
  validates_uniqueness_of :version, :scope => :name
end
