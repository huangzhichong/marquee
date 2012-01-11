require 'spec_helper'

describe "project_test_plans/new.html.haml" do
  before(:each) do
    assign(:project_test_plan, stub_model(ProjectTestPlan).as_new_record)
  end

  it "renders new project_test_plan form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => project_test_plans_path, :method => "post" do
    end
  end
end
