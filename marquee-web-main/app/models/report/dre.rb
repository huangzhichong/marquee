class Report::DRE
  include Mongoid::Document
  field :date, type: Date
  field :value, type: String

  embedded_in :project, inverse_of: :dres
end