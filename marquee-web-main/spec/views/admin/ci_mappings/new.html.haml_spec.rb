require 'spec_helper'

describe "admin/ci_mappings/new.html.haml" do
  before(:each) do
    assign(:admin_ci_mapping, stub_model(Admin::CiMapping).as_new_record)
  end

  it "renders new admin_ci_mapping form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_ci_mappings_path, :method => "post" do
    end
  end
end
