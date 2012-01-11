require "spec_helper"

describe MailNotifySettingsController do
  describe "routing" do

    it "routes to #index" do
      get("/mail_notify_settings").should route_to("mail_notify_settings#index")
    end

    it "routes to #new" do
      get("/mail_notify_settings/new").should route_to("mail_notify_settings#new")
    end

    it "routes to #show" do
      get("/mail_notify_settings/1").should route_to("mail_notify_settings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/mail_notify_settings/1/edit").should route_to("mail_notify_settings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/mail_notify_settings").should route_to("mail_notify_settings#create")
    end

    it "routes to #update" do
      put("/mail_notify_settings/1").should route_to("mail_notify_settings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/mail_notify_settings/1").should route_to("mail_notify_settings#destroy", :id => "1")
    end

  end
end
