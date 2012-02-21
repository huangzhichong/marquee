class AutomationDriverConfig < ActiveRecord::Base
  belongs_to :project
  belongs_to :automation_driver
  has_many :automation_scripts
  def as_json(options={})
    {
      extra_parameters: self.extra_parameters,
      source_paths: self.source_paths
    }
  end
end
