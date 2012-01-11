require 'spec_helper'

describe "admin/ci_mappings/show.html.haml" do
  before(:each) do
    @admin_ci_mapping = assign(:admin_ci_mapping, stub_model(Admin::CiMapping))
  end

  it "renders attributes in <p>" do
    render
  end
end
