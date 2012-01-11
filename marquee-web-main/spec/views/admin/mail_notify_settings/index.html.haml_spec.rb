require 'spec_helper'

describe "admin/mail_notify_settings/index.html.haml" do
  before(:each) do
    assign(:admin_mail_notify_settings, [
      stub_model(Admin::MailNotifySetting),
      stub_model(Admin::MailNotifySetting)
    ])
  end

  it "renders a list of admin/mail_notify_settings" do
    render
  end
end
