class AbilityDefinition < ActiveRecord::Base
  belongs_to :role
  
  acts_as_audited :protect => false
end
