require 'spec_helper'

describe "admin/team_members/new.html.haml" do
  before(:each) do
    assign(:admin_team_member, stub_model(Admin::TeamMember).as_new_record)
  end

  it "renders new admin_team_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_team_members_path, :method => "post" do
    end
  end
end
