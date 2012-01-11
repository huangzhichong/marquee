require 'spec_helper'

describe "admin/mail_notify_settings/show.html.haml" do
  before(:each) do
    @admin_mail_notify_setting = assign(:admin_mail_notify_setting, stub_model(Admin::MailNotifySetting))
  end

  it "renders attributes in <p>" do
    render
  end
end
