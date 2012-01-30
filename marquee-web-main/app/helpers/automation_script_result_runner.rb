class AutomationScriptResultRunner
  @queue = :marquee_farm

  def self.perform(automation_script_result_id)
    sa = SlaveAssignment.find_by_automation_script_result_id(automation_script_result_id)
    if sa
      sa.status = "pending"
      sa.save
    end
  end

  def self.rerun(automation_script_result_id)
    Resque.enqueue(AutomationScriptResultRunner, automation_script_result_id)
  end
end
