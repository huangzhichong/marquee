require 'spec_helper'

describe "test_cases/show.html.haml" do
  before(:each) do
    @test_case = assign(:test_case, stub_model(TestCase))
  end

  it "renders attributes in <p>" do
    render
  end
end
