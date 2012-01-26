require "spec_helper"

describe TestRound do
  let(:tr) {Factory(:test_round)}
  let(:ts) {Factory(:test_suite)}

  after(:each) do
    ts.automation_scripts.each do |as|
      as.delete
    end
    tr.automation_script_results.each do |asr|
      asr.delete
    end
    User.delete_all
  end

  it "can be instantiated" do
    tr.should be_an_instance_of(TestRound)
  end

  it "should have the start_time as nil when initiated" do
    tr.start_time.should be_nil
  end

  context "Test Round's start_time when re-run Automation Script Result " do
    before do
      2.times do
        ts.automation_scripts << Factory.create(:automation_script)
      end

      tr.test_suite = ts

      tr.save!
      tr.init_automation_script_result
      @asr = tr.automation_script_results[0]
      @asr2 = tr.automation_script_results[1]
    end

    it "should not have nil start_time when first Automation Script Result came" do
      @asr.update_state!("start")
      tr.update_state!
      tr.start_time.should_not be_nil
    end

    it "should have the start_time set to the first came Automation Script REsult" do
      @asr.update_state!("start")
      tr.update_state!
      tr.start_time.should eql @asr.start_time
    end

    it "should have the start_time set to the earliest time of its all Automation Script Results' start_time" do

      @asr.update_state!("start")
      @asr2.update_state!("start")
      tr.update_state!
      tr.start_time.should eql @asr.start_time
      tr.start_time.should_not eql @asr2.start_time
    end

    it "should have the earlist start time upon rerun test round." do
      @asr.update_state!("start")
      @asr2.update_state!("start")
      tr.update_state!
      @asr.update_state!("end")
      @asr2.update_state!("end")
      tr.update_state!

      @asr.clear
      @asr.update_state!("start")
      tr.update_state!
      tr.start_time.should eql @asr2.start_time

      @asr.update_state!("end")
      @asr2.update_state!("end")
      tr.update_state!
      @asr2.clear
      @asr2.update_state!("start")
      tr.update_state!
      tr.start_time.should eql @asr.start_time
    end

  end

end
