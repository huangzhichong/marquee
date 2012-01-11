require 'spec_helper'

describe "screen_shots/show.html.haml" do
  before(:each) do
    @screen_shot = assign(:screen_shot, stub_model(ScreenShot))
  end

  it "renders attributes in <p>" do
    render
  end
end
