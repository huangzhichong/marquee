class NodeAssociation < ActiveRecord::Base

  establish_connection :jira_sub
  self.table_name = "nodeassociation"
end
