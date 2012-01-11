class OracleProjectPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :oracle_project
end
