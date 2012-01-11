require 'spec_helper'

describe "admin/team_members/edit.html.haml" do
  before(:each) do
    @admin_team_member = assign(:admin_team_member, stub_model(Admin::TeamMember))
  end

  it "renders the edit admin_team_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_team_members_path(@admin_team_member), :method => "post" do
    end
  end
end
