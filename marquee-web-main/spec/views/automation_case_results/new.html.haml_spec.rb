require 'spec_helper'

describe "automation_case_results/new.html.haml" do
  before(:each) do
    assign(:automation_case_result, stub_model(AutomationCaseResult).as_new_record)
  end

  it "renders new automation_case_result form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => automation_case_results_path, :method => "post" do
    end
  end
end
