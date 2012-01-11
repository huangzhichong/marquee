require 'spec_helper'

describe "admin/ci_mappings/edit.html.haml" do
  before(:each) do
    @admin_ci_mapping = assign(:admin_ci_mapping, stub_model(Admin::CiMapping))
  end

  it "renders the edit admin_ci_mapping form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_ci_mappings_path(@admin_ci_mapping), :method => "post" do
    end
  end
end
