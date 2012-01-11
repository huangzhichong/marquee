# == Schema Information
#
# Table name: ci_mappings
#
#  id            :integer         not null, primary key
#  project_id    :integer
#  test_suite_id :integer
#  ci_value      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class CiMapping < ActiveRecord::Base
  belongs_to :project
  belongs_to :test_suite
end
