class CwdUser < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "cwd_user"
end
