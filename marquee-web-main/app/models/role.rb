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

  acts_as_audited :protect => false
end
