require 'spec_helper'

describe "mail_notify_settings/new.html.haml" do
  before(:each) do
    assign(:mail_notify_setting, stub_model(MailNotifySetting).as_new_record)
  end

  it "renders new mail_notify_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => mail_notify_settings_path, :method => "post" do
    end
  end
end
