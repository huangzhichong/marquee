require "test_helper"

class TestRoundTest < ActiveSupport::TestCase
  def setup
    # should run RAILS_ENV=test rake db:seed before run this test.
    @ts = TestSuite.new
    @ts.automation_scripts << AutomationScript.first
    @ts.automation_scripts << AutomationScript.last
    @ts.save

    @tr = TestRound.new
    @tr.test_suite = @ts
    @tr.test_object = 'test'
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

    asr.clear
    asr.update_state!('start')
    @tr.update_state!
    assert_equal asr2.start_time, @tr.start_time
  end

end
