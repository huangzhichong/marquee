require 'spec_helper'

describe "admin/test_suites/index.html.haml" do
  before(:each) do
    assign(:admin_test_suites, [
      stub_model(Admin::TestSuite),
      stub_model(Admin::TestSuite)
    ])
  end

  it "renders a list of admin/test_suites" do
    render
  end
end
