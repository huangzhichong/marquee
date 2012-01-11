class TimeCard::Record
  include Mongoid::Document

  field :name, type: String
  field :supervisor, type: String
  field :working, type: Integer
  field :submitted, type: Integer
  field :approved, type: Integer
  field :rejected, type: Integer

  belongs_to :weekly_record, class_name: "TimeCard::WeeklyRecord"
end