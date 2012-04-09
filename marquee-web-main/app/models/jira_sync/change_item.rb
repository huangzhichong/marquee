class ChangeItem < ActiveRecord::Base
  establish_connection :jira_sub
  self.table_name = "changeitem"
end
