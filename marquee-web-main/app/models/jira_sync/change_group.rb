class ChangeGroup < ActiveRecord::Base
  establish_connection :jira_sub
  self.table_name = "changegroup"
end
