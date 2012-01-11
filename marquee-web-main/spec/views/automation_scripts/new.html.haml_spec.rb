require 'spec_helper'

describe "automation_scripts/new.html.haml" do
  before(:each) do
    assign(:automation_script, stub_model(AutomationScript).as_new_record)
  end

  it "renders new automation_script form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => automation_scripts_path, :method => "post" do
    end
  end
end
