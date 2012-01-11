require 'spec_helper'

describe "project_categories/index.html.haml" do
  before(:each) do
    assign(:project_categories, [
      stub_model(ProjectCategory,
        :name => "Name"
      ),
      stub_model(ProjectCategory,
        :name => "Name"
      )
    ])
  end

  it "renders a list of project_categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
