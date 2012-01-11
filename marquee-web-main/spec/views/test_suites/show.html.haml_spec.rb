require 'spec_helper'

describe "test_suites/show.html.haml" do
  before(:each) do
    @test_suite = assign(:test_suite, stub_model(TestSuite))
  end

  it "renders attributes in <p>" do
    render
  end
end
