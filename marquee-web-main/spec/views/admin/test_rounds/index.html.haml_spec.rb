require 'spec_helper'

describe "admin/test_rounds/index.html.haml" do
  before(:each) do
    assign(:admin_test_rounds, [
      stub_model(Admin::TestRound),
      stub_model(Admin::TestRound)
    ])
  end

  it "renders a list of admin/test_rounds" do
    render
  end
end
