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
  belongs_to :project_category
  belongs_to :leader, :class_name => "User", :foreign_key => "leader_id"
  has_many :test_plans
  has_many :automation_scripts
  has_many :test_suites
  has_many :test_rounds
  has_many :ci_mappings
  has_many :mail_notify_settings
  has_many :automation_driver_configs
  has_attached_file :icon_image, :processors => [:cropper], :styles => { :large => "320x320", :medium => "180x180>", :thumb => "100x100>" }, :path => ":rails_root/public/images/projects/:style_:basename.:extension", :url => "/images/projects/:style_:basename.:extension"
  acts_as_audited :protect => false

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_icon_image, :if => :cropping?

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
    project_id = Project.find_by_name(project_name).id
    case priority
    when "Overall"
      automated_count = TestCase.includes("test_plan").where(:automated_status => "Automated", :test_plans => {:project_id => project_id,:status => "completed",:plan_type => plan_type}).count
      update_needed_count = TestCase.includes("test_plan").where(:automated_status => "Update Needed", :test_plans => {:project_id => project_id,:status => "completed",:plan_type => plan_type}).count
      cannot_count = TestCase.includes("test_plan").where(:automated_status => "Not a Candidate", :test_plans => {:project_id => project_id,:status => "completed",:plan_type => plan_type}).count
      all_count = TestCase.includes("test_plan").where(:test_plans => {:project_id => project_id,:status => "completed",:plan_type => plan_type}).count
    else
      automated_count = TestCase.includes("test_plan").where(:priority => priority, :automated_status => "Automated", :test_plans => {:project_id => project_id,:status => "completed",:plan_type => plan_type}).count
      update_needed_count = TestCase.includes("test_plan").where(:priority => priority, :automated_status => "Update Needed", :test_plans => {:project_id => project_id,:status => "completed",:plan_type => plan_type}).count
      cannot_count = TestCase.includes("test_plan").where(:priority => priority, :automated_status => "Not a Candidate", :test_plans => {:project_id => project_id,:status => "completed",:plan_type => plan_type}).count
      all_count = TestCase.includes("test_plan").where(:priority => priority, :test_plans => {:project_id => project_id,:status => "completed",:plan_type => plan_type}).count
    end
    coverage_value = ((all_count - cannot_count) <= 0 ? 0.0 : (automated_count+update_needed_count).to_f/(all_count - cannot_count).to_f)
    coverage_value = format("%.1f",coverage_value*100)
  end

  def self.caculate_coverage_by_project_and_priority(project_name, priority)
    coverage_value = 0.0
    project = Project.find_by_name(project_name)
    if project
      case priority
      when "Overall"
        automated_count = TestCase.includes("test_plan").where(:automated_status => "Automated", :test_plans => {:project_id => project.id,:status => "completed"}).count
        update_needed_count = TestCase.includes("test_plan").where(:automated_status => "Update Needed", :test_plans => {:project_id => project.id,:status => "completed"}).count
        cannot_count = TestCase.includes("test_plan").where(:automated_status => "Not a Candidate", :test_plans => {:project_id => project.id,:status => "completed"}).count
        all_count = TestCase.includes("test_plan").where(:test_plans => {:project_id => project.id,:status => "completed"}).count
      else
        automated_count = TestCase.includes("test_plan").where(:priority => priority, :automated_status => "Automated", :test_plans => {:project_id => project.id,:status => "completed"}).count
        update_needed_count = TestCase.includes("test_plan").where(:priority => priority, :automated_status => "Update Needed", :test_plans => {:project_id => project.id,:status => "completed"}).count
        cannot_count = TestCase.includes("test_plan").where(:priority => priority, :automated_status => "Not a Candidate", :test_plans => {:project_id => project.id,:status => "completed"}).count
        all_count = TestCase.includes("test_plan").where(:priority => priority, :test_plans => {:project_id => project.id,:status => "completed"}).count
      end
      coverage_value = ((all_count - cannot_count) <= 0 ? 0.0 : (automated_count+update_needed_count).to_f/(all_count - cannot_count).to_f)
      coverage_value = format("%.3f",coverage_value*100)
  end
  end

  private

  def reprocess_icon_image
    icon_image.reprocess!
  end

end
