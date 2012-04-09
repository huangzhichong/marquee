class FndJiraLocal < ActiveRecord::Base
  establish_connection :jira_sub
end
