require 'spec_helper'

describe "test_rounds/show.html.haml" do
  before(:each) do
    @test_round = assign(:test_round, stub_model(TestRound))
  end

  it "renders attributes in <p>" do
    render
  end
end
