module SlaveAssignmentsHelper

  def SlaveAssignmentsHelper.send_slave_assignment_to_list(slave_assignment, list_name)

    puts "Inserting into #{list_name} list: #{slave_assignment.inspect}"

    slave_assignments = $redis.hgetall :slave_assignments

    simplifiedSA = SimplifiedSlaveAssignment.new(slave_assignment)
    puts "simplifiedSA: #{simplifiedSA.inspect}"

    # if slave assignments is not nil and expected list has been created, update it
    slave_assignments.each do |name, value|
      sa_list = JSON.parse value
      puts "#{name} list: #{sa_list.inspect}"
      # remove it if it exist
      sa_list.reject! {|sa| sa.nil? || sa["id"] == simplifiedSA.id}
      # add to list if the list is what we expected to add in
      sa_list << simplifiedSA if name == list_name.to_s
      puts "Updated #{name} list: #{sa_list.inspect}"
      $redis.hset :slave_assignments, name, JSON.generate(sa_list)
      puts "Fetched #{name} list: #{$redis.hget :slave_assignments, name}"
    end 

    # if slave assignments is nil or expected list has't been created, create it
    if slave_assignments.nil? || !slave_assignments.has_key?(list_name.to_s)
      sa_list = Array.new
      sa_list << simplifiedSA
      puts "Newly created #{list_name} list: #{sa_list.inspect}"
      $redis.hset :slave_assignments, list_name, JSON.generate(sa_list)
    end

  end

end

class SimplifiedSlaveAssignment

  attr_accessor :id
  attr_accessor :slave_id

  def initialize(slave_assignment)
    @id = slave_assignment.id
    @slave_id = slave_assignment.slave_id
  end
end 
