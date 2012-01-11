require 'spec_helper'

describe "screen_shots/edit.html.haml" do
  before(:each) do
    @screen_shot = assign(:screen_shot, stub_model(ScreenShot))
  end

  it "renders the edit screen_shot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => screen_shots_path(@screen_shot), :method => "post" do
    end
  end
end
