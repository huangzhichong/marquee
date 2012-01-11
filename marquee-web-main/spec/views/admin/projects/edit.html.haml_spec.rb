require 'spec_helper'

describe "admin/projects/edit.html.haml" do
  before(:each) do
    @admin_project = assign(:admin_project, stub_model(Admin::Project))
  end

  it "renders the edit admin_project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_projects_path(@admin_project), :method => "post" do
    end
  end
end
