require 'spec_helper'

describe "admin/test_suites/show.html.haml" do
  before(:each) do
    @admin_test_suite = assign(:admin_test_suite, stub_model(Admin::TestSuite))
  end

  it "renders attributes in <p>" do
    render
  end
end
