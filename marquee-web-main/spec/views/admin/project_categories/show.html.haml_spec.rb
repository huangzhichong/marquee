require 'spec_helper'

describe "admin/project_categories/show.html.haml" do
  before(:each) do
    @admin_project_category = assign(:admin_project_category, stub_model(Admin::ProjectCategory))
  end

  it "renders attributes in <p>" do
    render
  end
end
