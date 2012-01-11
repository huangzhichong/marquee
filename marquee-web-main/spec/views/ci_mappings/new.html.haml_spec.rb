require 'spec_helper'

describe "ci_mappings/new.html.haml" do
  before(:each) do
    assign(:ci_mapping, stub_model(CiMapping).as_new_record)
  end

  it "renders new ci_mapping form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ci_mappings_path, :method => "post" do
    end
  end
end
