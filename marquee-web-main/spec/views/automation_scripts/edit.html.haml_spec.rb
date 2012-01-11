require 'spec_helper'

describe "automation_scripts/edit.html.haml" do
  before(:each) do
    @automation_script = assign(:automation_script, stub_model(AutomationScript))
  end

  it "renders the edit automation_script form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => automation_scripts_path(@automation_script), :method => "post" do
    end
  end
end
