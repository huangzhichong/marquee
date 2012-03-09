# == Schema Information
#
# Table name: project_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProjectCategory < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name, :message => " already exists."

  acts_as_audited :protect => false
end
