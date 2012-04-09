class Resolution < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "resolution"
end
