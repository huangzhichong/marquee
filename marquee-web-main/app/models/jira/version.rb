class Jira::Version
  include Mongoid::Document

  field :name, type: String
  has_and_belongs_to_many :jira_issues, class_name: "Jira::Issue", inverse_of: :fix_versions
end