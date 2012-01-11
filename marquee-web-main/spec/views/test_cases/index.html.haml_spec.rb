require 'spec_helper'

describe "test_cases/index.html.haml" do
  before(:each) do
    assign(:test_cases, [
      stub_model(TestCase),
      stub_model(TestCase)
    ])
  end

  it "renders a list of test_cases" do
    render
  end
end
