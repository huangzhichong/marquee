require 'spec_helper'

describe "mail_notify_settings/show.html.haml" do
  before(:each) do
    @mail_notify_setting = assign(:mail_notify_setting, stub_model(MailNotifySetting))
  end

  it "renders attributes in <p>" do
    render
  end
end
