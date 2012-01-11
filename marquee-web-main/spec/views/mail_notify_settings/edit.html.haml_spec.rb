require 'spec_helper'

describe "mail_notify_settings/edit.html.haml" do
  before(:each) do
    @mail_notify_setting = assign(:mail_notify_setting, stub_model(MailNotifySetting))
  end

  it "renders the edit mail_notify_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => mail_notify_settings_path(@mail_notify_setting), :method => "post" do
    end
  end
end
