# == Schema Information
#
# Table name: test_suites
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  status       :string(255)
#  project_id   :integer
#  creator_id   :integer
#  test_type_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class TestSuite < ActiveRecord::Base
  belongs_to :project
  belongs_to :test_type
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  has_many :suite_selections
  has_many :automation_scripts, :through => :suite_selections
  has_many :test_rounds
  has_many :ci_mappings
  
  acts_as_audited :protect => false, :only => [:create, :destroy]

  def automation_case_count
    self.automation_scripts.inject(0){|count,as| count + as.automation_cases.count}
  end
end
