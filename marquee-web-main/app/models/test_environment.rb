# == Schema Information
#
# Table name: test_environments
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class TestEnvironment < ActiveRecord::Base
  acts_as_audited :protect => false, :only => [:create, :destroy]
  
  def to_s
    self.name
  end
end
