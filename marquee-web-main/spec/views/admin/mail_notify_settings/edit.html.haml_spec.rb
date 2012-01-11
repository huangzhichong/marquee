require 'spec_helper'

describe "admin/mail_notify_settings/edit.html.haml" do
  before(:each) do
    @admin_mail_notify_setting = assign(:admin_mail_notify_setting, stub_model(Admin::MailNotifySetting))
  end

  it "renders the edit admin_mail_notify_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_mail_notify_settings_path(@admin_mail_notify_setting), :method => "post" do
    end
  end
end
