require 'spec_helper'

describe "admin/test_suites/edit.html.haml" do
  before(:each) do
    @admin_test_suite = assign(:admin_test_suite, stub_model(Admin::TestSuite))
  end

  it "renders the edit admin_test_suite form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_test_suites_path(@admin_test_suite), :method => "post" do
    end
  end
end
