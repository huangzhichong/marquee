require 'spec_helper'

describe "screen_shots/new.html.haml" do
  before(:each) do
    assign(:screen_shot, stub_model(ScreenShot).as_new_record)
  end

  it "renders new screen_shot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => screen_shots_path, :method => "post" do
    end
  end
end
