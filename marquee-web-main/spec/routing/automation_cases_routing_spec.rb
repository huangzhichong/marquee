require "spec_helper"

describe AutomationCasesController do
  describe "routing" do

    it "routes to #index" do
      get("/automation_cases").should route_to("automation_cases#index")
    end

    it "routes to #new" do
      get("/automation_cases/new").should route_to("automation_cases#new")
    end

    it "routes to #show" do
      get("/automation_cases/1").should route_to("automation_cases#show", :id => "1")
    end

    it "routes to #edit" do
      get("/automation_cases/1/edit").should route_to("automation_cases#edit", :id => "1")
    end

    it "routes to #create" do
      post("/automation_cases").should route_to("automation_cases#create")
    end

    it "routes to #update" do
      put("/automation_cases/1").should route_to("automation_cases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/automation_cases/1").should route_to("automation_cases#destroy", :id => "1")
    end

  end
end
