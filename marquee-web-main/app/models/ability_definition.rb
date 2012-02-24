class AbilityDefinition < ActiveRecord::Base
  # belongs_to :role
  has_and_belongs_to_many :roles
  
  acts_as_audited :protect => false
end
