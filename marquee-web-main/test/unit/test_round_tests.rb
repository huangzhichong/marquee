require "test_helper"

class TestRoundTest < ActiveSupport::TestCase
  def setup
    @ts = Factory(:test_suite)
    2.times do
      as = Factory(:automation_script)
      as.automation_cases << Factory(:automation_case)
      @ts.automation_scripts << as
      as.save!
    end
    @ts.save!

    @tr = Factory(:test_round)
    @tr.test_suite = @ts
    @tr.save
  end

  test "reset Test Round start time should initially be nil" do
    assert_nil @tr.start_time, "Initial Test Round's start time should be nil"
    @tr.init_automation_script_result
    assert_nil @tr.start_time, "Test Round's start time should still be nil after init asr."
    assert_equal 2, @tr.automation_script_results.count
  end

  test "upon recieve first asr, test round's start time shall change to it." do
    @tr.init_automation_script_result
    @tr.automation_script_results[0].update_state!("running")
    @tr.update_state!
    assert_not_nil @tr.start_time
  end

  test "test round's start time should be the earliest time among all its ASRs' start_time." do
    @tr.init_automation_script_result
    asr = @tr.automation_script_results[0]
    asr.update_state!('start')
    @tr.update_state!
    assert_equal asr.start_time, @tr.start_time

    asr2 = @tr.automation_script_results[1]
    asr2.update_state!('start')
    @tr.update_state!
    assert_equal asr.start_time, @tr.start_time

    asr.update_state!('end')
    asr2.update_state!('end')
    @tr.update_state!

    # simulate rerun a automation script. since now asr2's start_time shall be the earlist one, so test round's start_time shall be the same with it
    asr.clear
    asr.update_state!('start')
    @tr.update_state!
    assert_equal asr2.start_time, @tr.start_time
  end

end
