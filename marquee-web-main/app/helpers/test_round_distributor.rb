class TestRoundDistributor
  @queue = :marquee_farm

  def self.perform(test_round_id)
    test_round = TestRound.find(test_round_id)
    test_round.automation_script_results.each do |asr|
      driver = asr.automation_script.automation_driver.nil? ? 'qtp' : asr.automation_script.automation_driver.to_s

      sa = SlaveAssignment.create!
      sa.automation_script_result = asr

      # remove this because we'll assemble the command line string in the automation command
      # sa.command = "#{driver} $#{as.name} $BuildNumber=#{test_round.id} $AUT_ENV=#{test_round.test_environment.value} $MarketName=#{test_round.project.name} $TimeOut=#{time_out_limit}"

      sa.driver = driver
      sa.status = "pending"
      sa.save

      # besides saving it to db, we need to save sa to redis, too.
      # farm server will query redis instead of db to get the latest sa status
      SlaveAssignmentsHelper.send_slave_assignment_to_list sa, :pending
    end
  end

  def self.distribute(test_round_id)
    Resque.enqueue(TestRoundDistributor, test_round_id)
  end

end

