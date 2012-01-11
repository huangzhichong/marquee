require 'spec_helper'

describe "project_categories/new.html.haml" do
  before(:each) do
    assign(:project_category, stub_model(ProjectCategory,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new project_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => project_categories_path, :method => "post" do
      assert_select "input#project_category_name", :name => "project_category[name]"
    end
  end
end
