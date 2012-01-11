require 'spec_helper'

describe "project_test_plans/edit.html.haml" do
  before(:each) do
    @project_test_plan = assign(:project_test_plan, stub_model(ProjectTestPlan))
  end

  it "renders the edit project_test_plan form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => project_test_plans_path(@project_test_plan), :method => "post" do
    end
  end
end
