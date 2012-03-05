class OperationSystem < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :version
  validates_uniqueness_of :version, :scope => :name
end
