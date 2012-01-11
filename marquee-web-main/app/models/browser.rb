# == Schema Information
#
# Table name: browsers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  version    :string(255)
#  machine_id :integer
#  allowed    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Browser < ActiveRecord::Base
  belongs_to :machine
end
