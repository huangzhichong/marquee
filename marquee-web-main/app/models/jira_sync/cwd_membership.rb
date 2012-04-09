class CwdMembership < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "cwd_membership"
end
