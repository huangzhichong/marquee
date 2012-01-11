require 'spec_helper'

describe "mail_notify_settings/index.html.haml" do
  before(:each) do
    assign(:mail_notify_settings, [
      stub_model(MailNotifySetting),
      stub_model(MailNotifySetting)
    ])
  end

  it "renders a list of mail_notify_settings" do
    render
  end
end
