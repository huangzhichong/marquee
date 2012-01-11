class Report::TechnicalDebt
  include Mongoid::Document
  field :date, type: Date
  field :priority_0, type: String
  field :priority_1, type: String
  field :priority_2, type: String
  field :priority_3, type: String
  field :priority_4, type: String

  embedded_in :project, inverse_of: :technical_debts
end