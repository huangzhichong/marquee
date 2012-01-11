require 'spec_helper'

describe "project_test_plans/index.html.haml" do
  before(:each) do
    assign(:project_test_plans, [
      stub_model(ProjectTestPlan),
      stub_model(ProjectTestPlan)
    ])
  end

  it "renders a list of project_test_plans" do
    render
  end
end
