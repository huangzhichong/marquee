require 'spec_helper'

describe "automation_case_results/edit.html.haml" do
  before(:each) do
    @automation_case_result = assign(:automation_case_result, stub_model(AutomationCaseResult))
  end

  it "renders the edit automation_case_result form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => automation_case_results_path(@automation_case_result), :method => "post" do
    end
  end
end
