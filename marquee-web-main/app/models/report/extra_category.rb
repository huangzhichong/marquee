class Report::ExtraCategory
  include Mongoid::Document

  field :name, type: String
  field :jira_key, type: String

  embedded_in :config, class_name: "Report::InDevelopmentTrackingConfig"
end