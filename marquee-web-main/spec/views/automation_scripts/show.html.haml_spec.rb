require 'spec_helper'

describe "automation_scripts/show.html.haml" do
  before(:each) do
    @automation_script = assign(:automation_script, stub_model(AutomationScript))
  end

  it "renders attributes in <p>" do
    render
  end
end
