require 'spec_helper'

describe "ci_mappings/show.html.haml" do
  before(:each) do
    @ci_mapping = assign(:ci_mapping, stub_model(CiMapping))
  end

  it "renders attributes in <p>" do
    render
  end
end
