require 'spec_helper'

describe "admin/projects/new.html.haml" do
  before(:each) do
    assign(:admin_project, stub_model(Admin::Project).as_new_record)
  end

  it "renders new admin_project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_projects_path, :method => "post" do
    end
  end
end
