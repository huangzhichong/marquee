require 'spec_helper'

describe "project_test_plans/show.html.haml" do
  before(:each) do
    @project_test_plan = assign(:project_test_plan, stub_model(ProjectTestPlan))
  end

  it "renders attributes in <p>" do
    render
  end
end
