require 'spec_helper'

describe "admin/projects/show.html.haml" do
  before(:each) do
    @admin_project = assign(:admin_project, stub_model(Admin::Project))
  end

  it "renders attributes in <p>" do
    render
  end
end
