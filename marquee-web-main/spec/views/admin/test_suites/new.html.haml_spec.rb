require 'spec_helper'

describe "admin/test_suites/new.html.haml" do
  before(:each) do
    assign(:admin_test_suite, stub_model(Admin::TestSuite).as_new_record)
  end

  it "renders new admin_test_suite form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_test_suites_path, :method => "post" do
    end
  end
end
