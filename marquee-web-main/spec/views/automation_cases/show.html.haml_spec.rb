require 'spec_helper'

describe "automation_cases/show.html.haml" do
  before(:each) do
    @automation_case = assign(:automation_case, stub_model(AutomationCase))
  end

  it "renders attributes in <p>" do
    render
  end
end
