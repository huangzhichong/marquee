class OracleProject < ActiveRecord::Base
  has_many :oracle_project_permissions
  has_many :users, :through => :oracle_project_permissions

end
