require 'spec_helper'

describe "admin/project_categories/edit.html.haml" do
  before(:each) do
    @admin_project_category = assign(:admin_project_category, stub_model(Admin::ProjectCategory))
  end

  it "renders the edit admin_project_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_project_categories_path(@admin_project_category), :method => "post" do
    end
  end
end
