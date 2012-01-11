require 'spec_helper'

describe "admin/mail_notify_settings/new.html.haml" do
  before(:each) do
    assign(:admin_mail_notify_setting, stub_model(Admin::MailNotifySetting).as_new_record)
  end

  it "renders new admin_mail_notify_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_mail_notify_settings_path, :method => "post" do
    end
  end
end
