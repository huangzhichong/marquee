require 'spec_helper'

describe "test_suites/index.html.haml" do
  before(:each) do
    assign(:test_suites, [
      stub_model(TestSuite),
      stub_model(TestSuite)
    ])
  end

  it "renders a list of test_suites" do
    render
  end
end
