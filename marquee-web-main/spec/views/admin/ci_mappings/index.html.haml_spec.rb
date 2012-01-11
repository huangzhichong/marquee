require 'spec_helper'

describe "admin/ci_mappings/index.html.haml" do
  before(:each) do
    assign(:admin_ci_mappings, [
      stub_model(Admin::CiMapping),
      stub_model(Admin::CiMapping)
    ])
  end

  it "renders a list of admin/ci_mappings" do
    render
  end
end
