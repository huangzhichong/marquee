class Jira::Group
  include Mongoid::Document

  field :name, type: String

  has_many :work_logs, class_name: "Jira::WorkLog2"
end