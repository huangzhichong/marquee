require 'spec_helper'

describe "automation_script_results/index.html.haml" do
  before(:each) do
    assign(:automation_script_results, [
      stub_model(AutomationScriptResult),
      stub_model(AutomationScriptResult)
    ])
  end

  it "renders a list of automation_script_results" do
    render
  end
end
