require 'spec_helper'

describe "project_categories/edit.html.haml" do
  before(:each) do
    @project_category = assign(:project_category, stub_model(ProjectCategory,
      :name => "MyString"
    ))
  end

  it "renders the edit project_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => project_categories_path(@project_category), :method => "post" do
      assert_select "input#project_category_name", :name => "project_category[name]"
    end
  end
end
