require 'spec_helper'

describe "automation_script_results/edit.html.haml" do
  before(:each) do
    @automation_script_result = assign(:automation_script_result, stub_model(AutomationScriptResult))
  end

  it "renders the edit automation_script_result form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => automation_script_results_path(@automation_script_result), :method => "post" do
    end
  end
end
