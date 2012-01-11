require 'spec_helper'

describe "admin/project_categories/new.html.haml" do
  before(:each) do
    assign(:admin_project_category, stub_model(Admin::ProjectCategory).as_new_record)
  end

  it "renders new admin_project_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_project_categories_path, :method => "post" do
    end
  end
end
