class Jira::Requirement < Jira::Issue  

  def bug_count
    children.where(issue_type: 'Bug Sub-Task').count
  end
end