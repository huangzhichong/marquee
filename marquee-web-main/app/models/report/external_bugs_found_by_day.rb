class Report::ExternalBugsFoundByDay
  include Mongoid::Document
  field :date, type: Date
  field :severity_1, type: String
  field :severity_2, type: String

  embedded_in :project, inverse_of: :external_bugs_found_by_days
end