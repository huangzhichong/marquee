require 'spec_helper'

describe "admin/team_members/show.html.haml" do
  before(:each) do
    @admin_team_member = assign(:admin_team_member, stub_model(Admin::TeamMember))
  end

  it "renders attributes in <p>" do
    render
  end
end
