class Jira::Bug < Jira::Issue
  field :environment_was_found, type: String
  field :who_found, type: String
  field :defect_origin, type: String
  field :how_bug_was_found, type: String
  field :resolution, type: String
  
end