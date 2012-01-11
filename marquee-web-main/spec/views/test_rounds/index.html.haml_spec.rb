require 'spec_helper'

describe "test_rounds/index.html.haml" do
  before(:each) do
    assign(:test_rounds, [
      stub_model(TestRound),
      stub_model(TestRound)
    ])
  end

  it "renders a list of test_rounds" do
    render
  end
end
