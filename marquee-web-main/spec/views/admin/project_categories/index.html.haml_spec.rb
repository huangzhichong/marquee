require 'spec_helper'

describe "admin/project_categories/index.html.haml" do
  before(:each) do
    assign(:admin_project_categories, [
      stub_model(Admin::ProjectCategory),
      stub_model(Admin::ProjectCategory)
    ])
  end

  it "renders a list of admin/project_categories" do
    render
  end
end
