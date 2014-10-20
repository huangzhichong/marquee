class ErrorType < ActiveRecord::Base
  has_many :automation_script_results
end
