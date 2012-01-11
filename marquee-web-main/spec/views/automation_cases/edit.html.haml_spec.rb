require 'spec_helper'

describe "automation_cases/edit.html.haml" do
  before(:each) do
    @automation_case = assign(:automation_case, stub_model(AutomationCase))
  end

  it "renders the edit automation_case form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => automation_cases_path(@automation_case), :method => "post" do
    end
  end
end
