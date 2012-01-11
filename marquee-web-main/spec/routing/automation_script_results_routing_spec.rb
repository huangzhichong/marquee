require "spec_helper"

describe AutomationScriptResultsController do
  describe "routing" do

    it "routes to #index" do
      get("/automation_script_results").should route_to("automation_script_results#index")
    end

    it "routes to #new" do
      get("/automation_script_results/new").should route_to("automation_script_results#new")
    end

    it "routes to #show" do
      get("/automation_script_results/1").should route_to("automation_script_results#show", :id => "1")
    end

    it "routes to #edit" do
      get("/automation_script_results/1/edit").should route_to("automation_script_results#edit", :id => "1")
    end

    it "routes to #create" do
      post("/automation_script_results").should route_to("automation_script_results#create")
    end

    it "routes to #update" do
      put("/automation_script_results/1").should route_to("automation_script_results#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/automation_script_results/1").should route_to("automation_script_results#destroy", :id => "1")
    end

  end
end
