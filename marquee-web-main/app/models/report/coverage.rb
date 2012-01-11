class Report::Coverage
  include Mongoid::Document
  field :priority, type: String
  field :value, type: Float
  field :goal, type: Float

  embedded_in :project, inverse_of: :coverages
end