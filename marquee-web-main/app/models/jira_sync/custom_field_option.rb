class CustomFieldOption < ActiveRecord::Base
  establish_connection :jira_sub
  self.table_name = "customfieldoption"
end
