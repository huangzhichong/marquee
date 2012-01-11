class TimeCard::WeeklyRecord
  include Mongoid::Document

  field :last_import, type: Date
  field :from, type: Date
  field :to, type: Date

  has_many :records, class_name: "TimeCard::Record"
end