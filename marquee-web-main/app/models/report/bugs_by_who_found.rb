class Report::BugsByWhoFound
  include Mongoid::Document
  field :date, type: Date
  field :external, type: String
  field :internal, type: String
  field :closed_requirements, type: String

  embedded_in :project, inverse_of: :bugs_by_who_founds
end