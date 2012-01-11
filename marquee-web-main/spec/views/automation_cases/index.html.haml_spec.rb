require 'spec_helper'

describe "automation_cases/index.html.haml" do
  before(:each) do
    assign(:automation_cases, [
      stub_model(AutomationCase),
      stub_model(AutomationCase)
    ])
  end

  it "renders a list of automation_cases" do
    render
  end
end
