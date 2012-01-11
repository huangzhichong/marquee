require 'spec_helper'

describe "ci_mappings/edit.html.haml" do
  before(:each) do
    @ci_mapping = assign(:ci_mapping, stub_model(CiMapping))
  end

  it "renders the edit ci_mapping form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ci_mappings_path(@ci_mapping), :method => "post" do
    end
  end
end
