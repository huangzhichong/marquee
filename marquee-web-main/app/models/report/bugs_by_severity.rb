class Report::BugsBySeverity
  include Mongoid::Document
  field :date, type: Date
  field :severity_1, type: String
  field :severity_2, type: String
  field :severity_3, type: String
  field :severity_4, type: String
  field :severity_nyd, type: String

  embedded_in :project, inverse_of: :bugs_by_severities
end