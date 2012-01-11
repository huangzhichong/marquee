require 'spec_helper'

describe "admin/projects/index.html.haml" do
  before(:each) do
    assign(:admin_projects, [
      stub_model(Admin::Project),
      stub_model(Admin::Project)
    ])
  end

  it "renders a list of admin/projects" do
    render
  end
end
