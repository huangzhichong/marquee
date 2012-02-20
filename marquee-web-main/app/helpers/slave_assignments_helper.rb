module SlaveAssignmentsHelper

  def SlaveAssignmentsHelper.send_slave_assignment_to_list(slave_assignment, list_name)

    slave_assignments = $redis.hgetall :slave_assignments

    simplifiedSA = SimplifiedSlaveAssignment.new(slave_assignment)

    # if slave assignments is not nil and expected list has been created, update it
    slave_assignments.each do |name, value|
      sa_list = JSON.parse value
      # remove it if it exist
      sa_list.reject! {|sa| sa.nil? || sa["id"] == simplifiedSA.id}
      # add to list if the list is what we expected to add in
      sa_list << JSON.parse(simplifiedSA.to_json) if name == list_name.to_s
      $redis.hset :slave_assignments, name, JSON.generate(sa_list)
    end 

    # if slave assignments is nil or expected list has't been created, create it
    if slave_assignments.nil? || !slave_assignments.has_key?(list_name.to_s)
      sa_list = Array.new
      sa_list << JSON.parse(simplifiedSA.to_json)
      $redis.hset :slave_assignments, list_name, JSON.generate(sa_list)
    end

  end

end

class SimplifiedSlaveAssignment

  attr_accessor :id
  attr_accessor :slave_id
  attr_accessor :time_out_limit
  attr_accessor :created_at
  attr_accessor :updated_at

  def initialize(slave_assignment)
    @id = slave_assignment.id
    @slave_id = slave_assignment.slave_id
    @time_out_limit = slave_assignment.automation_script_result.automation_script.time_out_limit
    @created_at = slave_assignment.created_at
    @updated_at = slave_assignment.updated_at
  end
end 
