require 'spec_helper'

describe "admin/test_rounds/edit.html.haml" do
  before(:each) do
    @admin_test_round = assign(:admin_test_round, stub_model(Admin::TestRound))
  end

  it "renders the edit admin_test_round form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_test_rounds_path(@admin_test_round), :method => "post" do
    end
  end
end
