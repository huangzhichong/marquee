require "spec_helper"

describe AutomationScriptsController do
  describe "routing" do

    it "routes to #index" do
      get("/automation_scripts").should route_to("automation_scripts#index")
    end

    it "routes to #new" do
      get("/automation_scripts/new").should route_to("automation_scripts#new")
    end

    it "routes to #show" do
      get("/automation_scripts/1").should route_to("automation_scripts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/automation_scripts/1/edit").should route_to("automation_scripts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/automation_scripts").should route_to("automation_scripts#create")
    end

    it "routes to #update" do
      put("/automation_scripts/1").should route_to("automation_scripts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/automation_scripts/1").should route_to("automation_scripts#destroy", :id => "1")
    end

  end
end
