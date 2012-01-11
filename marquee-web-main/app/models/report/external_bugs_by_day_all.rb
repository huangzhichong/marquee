class Report::ExternalBugsByDayAll
  include Mongoid::Document
  field :date, type: Date
  field :endurance, type:String
  field :camps, type:String
  field :sports, type:String
  field :swimming, type:String
  field :membership, type:String
  field :platform, type:String
  field :framework, type:String

  embedded_in :project, inverse_of: :external_bugs_by_day_alls
end