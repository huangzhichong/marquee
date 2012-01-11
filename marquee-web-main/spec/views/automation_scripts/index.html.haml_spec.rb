require 'spec_helper'

describe "automation_scripts/index.html.haml" do
  before(:each) do
    assign(:automation_scripts, [
      stub_model(AutomationScript),
      stub_model(AutomationScript)
    ])
  end

  it "renders a list of automation_scripts" do
    render
  end
end
