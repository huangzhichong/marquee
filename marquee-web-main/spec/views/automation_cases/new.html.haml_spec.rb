require 'spec_helper'

describe "automation_cases/new.html.haml" do
  before(:each) do
    assign(:automation_case, stub_model(AutomationCase).as_new_record)
  end

  it "renders new automation_case form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => automation_cases_path, :method => "post" do
    end
  end
end
