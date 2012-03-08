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
  has_many :projects_roles, :class_name => "ProjectsRoles", :dependent => :delete_all

  validates :name, :presence => true, :uniqueness => true

  acts_as_audited :protect => false

  def could_be_deleted?
    ProjectsRoles.find_all_by_role_id(id).each do |pr|
      return false if !ProjectsRolesUsers.find_all_by_projects_roles_id(pr.id).empty?
    end

    return true;
  end

end
