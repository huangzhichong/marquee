require 'spec_helper'

describe "admin/test_rounds/new.html.haml" do
  before(:each) do
    assign(:admin_test_round, stub_model(Admin::TestRound).as_new_record)
  end

  it "renders new admin_test_round form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_test_rounds_path, :method => "post" do
    end
  end
end
