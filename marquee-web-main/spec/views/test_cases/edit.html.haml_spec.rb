require 'spec_helper'

describe "test_cases/edit.html.haml" do
  before(:each) do
    @test_case = assign(:test_case, stub_model(TestCase))
  end

  it "renders the edit test_case form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => test_cases_path(@test_case), :method => "post" do
    end
  end
end
