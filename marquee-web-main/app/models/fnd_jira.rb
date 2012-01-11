class FndJira < ActiveRecord::Base
  establish_connection Rails.configuration.database_configuration['fnd_jira']
end