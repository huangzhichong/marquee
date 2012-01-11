require 'spec_helper'

describe "test_rounds/new.html.haml" do
  before(:each) do
    assign(:test_round, stub_model(TestRound).as_new_record)
  end

  it "renders new test_round form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => test_rounds_path, :method => "post" do
    end
  end
end
