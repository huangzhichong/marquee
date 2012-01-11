class Report::Record
  include Mongoid::Document

  field :total_time_worked, type: Integer
  field :in_release_time_worked, type: Integer
  field :out_of_release_time_worked, type: Integer
  field :out_of_project_time_worked, type: Integer
  field :total_open_bugs_count, type: Integer
  field :p0_open_bugs_count, type: Integer
  field :p1_open_bugs_count, type: Integer
  field :p2_open_bugs_count, type: Integer
  field :p3_open_bugs_count, type: Integer
  field :p4_open_bugs_count, type: Integer

  field :daily_open_bugs_count_string, type: String

  field :generated_at, type: DateTime
end