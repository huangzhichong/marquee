require 'spec_helper'

describe "admin/team_members/index.html.haml" do
  before(:each) do
    assign(:admin_team_members, [
      stub_model(Admin::TeamMember),
      stub_model(Admin::TeamMember)
    ])
  end

  it "renders a list of admin/team_members" do
    render
  end
end
