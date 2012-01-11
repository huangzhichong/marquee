require 'spec_helper'

describe "test_rounds/edit.html.haml" do
  before(:each) do
    @test_round = assign(:test_round, stub_model(TestRound))
  end

  it "renders the edit test_round form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => test_rounds_path(@test_round), :method => "post" do
    end
  end
end
