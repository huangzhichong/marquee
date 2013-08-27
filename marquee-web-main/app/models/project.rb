# == Schema Information
#
# Table name: projects
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  leader_id               :integer
#  project_category_id     :integer
#  source_control_path     :string(255)
#  icon_image_file_name    :string(255)
#  icon_image_content_type :string(255)
#  icon_image_file_size    :integer
#  state                   :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

class Project < ActiveRecord::Base

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_icon_image, :if => :cropping?

  has_many :project_browser_configs
  has_many :browsers, :through => :project_browser_configs
  accepts_nested_attributes_for :project_browser_configs

  has_many :project_operation_system_configs
  has_many :operation_systems, :through => :project_operation_system_configs
  accepts_nested_attributes_for :project_operation_system_configs

  belongs_to :project_category
  belongs_to :leader, :class_name => "User", :foreign_key => "leader_id"
  has_many :test_plans
  has_many :automation_scripts
  has_many :test_suites
  has_many :test_rounds
  has_many :ci_mappings
  has_many :mail_notify_settings
  has_many :automation_driver_configs
  has_many :projects_roles, :class_name => "ProjectsRoles", :dependent => :destroy
  has_attached_file :icon_image, :default_url => "/images/projects/default_project.png", :processors => [:cropper], :styles => { :large => "320x320", :medium => "180x180>", :thumb => "100x100>" }, :path => ":rails_root/public/images/projects/:style_:basename.:extension", :url => "/images/projects/:style_:basename.:extension"
  acts_as_audited :protect => false

  validates_presence_of :name, :browsers, :operation_systems
  validates_uniqueness_of :name, :message => " already exists."

  def to_s
    self.name
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def icon_image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(icon_image.path(style))
  end

  def self.caculate_coverage_by_project_and_priority_and_type(project_name, priority,plan_type)
    project = Project.find_by_name(project_name)
    if project
      case priority
      when "Overall"
        automated_count = project.count_test_case_by_plan_type_and_options(plan_type, {:automated_status => "Automated"})
        update_needed_count = project.count_test_case_by_plan_type_and_options(plan_type, {:automated_status => "Update Needed"})
        cannot_count = project.count_test_case_by_plan_type_and_options(plan_type, {:automated_status => "Not a Candidate"})
        manual = project.count_test_case_by_plan_type_and_options(plan_type, {:automated_status => "Manual"})
        all_count = project.count_test_case_by_plan_type_and_options(plan_type)
      else
        automated_count = project.count_test_case_by_plan_type_and_options(plan_type, {:automated_status => "Automated",:priority => priority})
        update_needed_count = project.count_test_case_by_plan_type_and_options(plan_type, {:automated_status => "Update Needed",:priority => priority})
        cannot_count = project.count_test_case_by_plan_type_and_options(plan_type, {:automated_status => "Not a Candidate",:priority => priority})
        manual = project.count_test_case_by_plan_type_and_options(plan_type, {:automated_status => "Manual",:priority => priority})
        all_count = project.count_test_case_by_plan_type_and_options(plan_type, {:priority => priority})
      end
      coverage_value = ((all_count - cannot_count - manual) <= 0 ? 0.0 : (automated_count+update_needed_count).to_f/(all_count - cannot_count - manual).to_f)
      coverage_value = format("%.1f",coverage_value*100)
    end
  end

  def self.caculate_coverage_by_project_and_priority(project_name,priority)
    coverage_value = 0.0
    project = Project.find_by_name(project_name)
    if project
      case priority
      when "Overall"
        automated_count = project.count_test_case_by_options(:automated_status => "Automated")
        update_needed_count = project.count_test_case_by_options(:automated_status => "Update Needed")
        cannot_count = project.count_test_case_by_options(:automated_status => "Not a Candidate")
        manual = project.count_test_case_by_options(:automated_status => "Manual")
        all_count = project.count_test_case_by_options
      else
        automated_count = project.count_test_case_by_options({:automated_status => "Automated",:priority => priority})
        update_needed_count = project.count_test_case_by_options({:automated_status => "Update Needed",:priority => priority})
        cannot_count = project.count_test_case_by_options({:automated_status => "Not a Candidate",:priority => priority})
        manual = project.count_test_case_by_options({:automated_status => "Manual",:priority => priority})
        all_count = project.count_test_case_by_options(:priority => priority)
      end
      coverage_value = ((all_count - cannot_count - manual) <= 0 ? 0.0 : (automated_count+update_needed_count).to_f/(all_count - cannot_count - manual).to_f)
      coverage_value = format("%.3f",coverage_value*100)
    end
  end

  def count_test_case_by_options(options={})
    options[:test_plans] = {:project_id => self.id,:status => "completed"}
    TestCase.includes("test_plan").where(options).where("test_cases.version > 0").count
  end

  def count_test_case_by_plan_type_and_options(plan_type,options={})
    options[:test_plans] = {:plan_type => plan_type, :project_id => self.id, :status => "completed"}
    TestCase.includes("test_plan").where(options).where("test_cases.version > 0").count
  end



  private

  def reprocess_icon_image
    icon_image.reprocess!
  end

end
