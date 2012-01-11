require 'spec_helper'

describe "automation_case_results/show.html.haml" do
  before(:each) do
    @automation_case_result = assign(:automation_case_result, stub_model(AutomationCaseResult))
  end

  it "renders attributes in <p>" do
    render
  end
end
