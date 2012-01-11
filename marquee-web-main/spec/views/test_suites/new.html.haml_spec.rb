require 'spec_helper'

describe "test_suites/new.html.haml" do
  before(:each) do
    assign(:test_suite, stub_model(TestSuite).as_new_record)
  end

  it "renders new test_suite form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => test_suites_path, :method => "post" do
    end
  end
end
