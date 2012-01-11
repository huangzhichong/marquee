require 'spec_helper'

describe "automation_case_results/index.html.haml" do
  before(:each) do
    assign(:automation_case_results, [
      stub_model(AutomationCaseResult),
      stub_model(AutomationCaseResult)
    ])
  end

  it "renders a list of automation_case_results" do
    render
  end
end
