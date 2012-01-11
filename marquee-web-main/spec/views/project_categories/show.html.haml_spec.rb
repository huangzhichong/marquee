require 'spec_helper'

describe "project_categories/show.html.haml" do
  before(:each) do
    @project_category = assign(:project_category, stub_model(ProjectCategory,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
