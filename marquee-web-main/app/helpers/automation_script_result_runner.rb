class AutomationScriptResultRunner
  @queue = :marquee_farm

  def self.perform(automation_script_result_id)
    sa = SlaveAssignment.find_by_automation_script_result_id(automation_script_result_id)
    if sa
      # sa.status = "pending"
      sa.reset!
      sa.save

      # besides saving it to db, we need to save sa to redis, too.
      # farm server will query redis instead of db to get the latest sa status
      SlaveAssignmentsHelper.send_slave_assignment_to_list sa, :pending
    end
  end

  def self.rerun(automation_script_result_id)
    Resque.enqueue(AutomationScriptResultRunner, automation_script_result_id)
  end
end
