class Report::InDevelopmentTrackingConfig
  include Mongoid::Document

  field :name, type: String
  field :jira_project, type: String
  field :jira_key, type: String
  field :jira_group, type: String
  field :jira_version, type: String
  field :start_date, type: Date
  field :end_date, type: Date

  embeds_many :extra_categories, class_name: "Report::ExtraCategory"
  embeds_many :trackings, class_name: "Report::Tracking"

  validates_presence_of :jira_project, :jira_version, :jira_key, :jira_group, :start_date, :end_date
  after_validation :generate_name

  protected
  # generate default name when no name given
  def generate_name
    self.name = "Tracking for #{jira_project} - #{jira_version}" if (self.name.blank? and self.errors.empty?)
  end
end