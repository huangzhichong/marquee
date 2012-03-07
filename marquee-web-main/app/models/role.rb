# == Schema Information
#
# Table name: roles
#
#  id   :integer         not null, primary key
#  name :string(255)
#

class Role < ActiveRecord::Base
  # has_and_belongs_to_many :users
  has_and_belongs_to_many :ability_definitions

  validates :name, :presence => true, :uniqueness => true

  acts_as_audited :protect => false

  def could_be_deleted?
    return ProjectsRoles.find_all_by_role_id(id).empty?
  end

end
