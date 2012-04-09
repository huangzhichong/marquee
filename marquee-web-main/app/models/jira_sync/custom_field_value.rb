class CustomFieldValue < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "customfieldvalue"
end
