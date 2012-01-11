require 'spec_helper'

describe "screen_shots/index.html.haml" do
  before(:each) do
    assign(:screen_shots, [
      stub_model(ScreenShot),
      stub_model(ScreenShot)
    ])
  end

  it "renders a list of screen_shots" do
    render
  end
end
