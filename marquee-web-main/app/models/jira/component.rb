class Jira::Component
  include Mongoid::Document

  field :name, type: String

  has_and_belongs_to_many :issues, class_name: "Jira::Issue"
end