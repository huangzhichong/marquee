require 'spec_helper'

describe "automation_script_results/show.html.haml" do
  before(:each) do
    @automation_script_result = assign(:automation_script_result, stub_model(AutomationScriptResult))
  end

  it "renders attributes in <p>" do
    render
  end
end
