require 'spec_helper'

describe "AutomationCaseResults" do
  describe "GET /automation_case_results" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get automation_case_results_path
      response.status.should be(200)
    end
  end
end
