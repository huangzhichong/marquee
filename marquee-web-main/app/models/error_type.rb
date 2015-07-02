class ErrorType < ActiveRecord::Base
  has_many :automation_script_results

  def self.non_editable_ids    
    ErrorType.where("name in (?)",['Script Error','Not in Branch']).map(&:id)
  end
end
