require 'spec_helper'

describe "admin/test_rounds/show.html.haml" do
  before(:each) do
    @admin_test_round = assign(:admin_test_round, stub_model(Admin::TestRound))
  end

  it "renders attributes in <p>" do
    render
  end
end
