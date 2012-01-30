class TestRoundDistributor
  @queue = :marquee_farm

  def self.perform(test_round)
    test_round.automation_script_results.each do |asr|
      driver = asr.automation_script.automation_driver.nil? ? 'qtp' : asr.automation_script.automation_driver.to_s

      sa = SlaveAssignment.create!
      sa.automation_script_result = asr

      # remove this because we'll assemble the command line string in the automation command
      # sa.command = "#{driver} $#{as.name} $BuildNumber=#{test_round.id} $AUT_ENV=#{test_round.test_environment.value} $MarketName=#{test_round.project.name} $TimeOut=#{time_out_limit}"

      sa.driver = driver
      sa.status = "pending"
      sa.save
    end
  end

  def self.distribute(test_round)
    Resque.enqueue(TestRoundDistributor, test_round)
  end

end
