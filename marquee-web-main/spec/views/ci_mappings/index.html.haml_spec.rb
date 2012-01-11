require 'spec_helper'

describe "ci_mappings/index.html.haml" do
  before(:each) do
    assign(:ci_mappings, [
      stub_model(CiMapping),
      stub_model(CiMapping)
    ])
  end

  it "renders a list of ci_mappings" do
    render
  end
end
