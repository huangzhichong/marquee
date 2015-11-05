class ErrorType < ActiveRecord::Base
  has_many :automation_script_results

  def self.pass_and_failed_options
    ErrorType.where("result_type in ('pass','failed')").map{|e| ["#{e.result_type.upcase} - #{e.name}", e.id]}
  end

  def self.pass_options
    ErrorType.where("result_type in ('pass')").map{|e| ["#{e.result_type.upcase} - #{e.name}", e.id]}
  end

  def  self.all_options
    ErrorType.all.map{|e| ["#{e.result_type.upcase} - #{e.name}", e.id]}
  end
end
