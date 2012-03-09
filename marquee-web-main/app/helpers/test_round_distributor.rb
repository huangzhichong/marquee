class TestRoundDistributor
  @queue = :marquee_farm

  def self.perform(test_round_id)
    test_round = TestRound.find(test_round_id)
    test_round.automation_script_results.each do |asr|
      sa = SlaveAssignment.create!
      sa.automation_script_result = asr
      sa.status = "pending"
      sa.browser_name = test_round.browser.name
      sa.browser_version = test_round.browser.version
      sa.operation_system_name = test_round.operation_system.name
      sa.operation_system_version = test_round.operation_system.version
      sa.save!

      # besides saving it to db, we need to save sa to redis, too.
      # farm server will query redis instead of db to get the latest sa status
      SlaveAssignmentsHelper.send_slave_assignment_to_list sa, :pending
    end
  end

  def self.distribute(test_round_id)
    Resque.enqueue(TestRoundDistributor, test_round_id)
  end

end
