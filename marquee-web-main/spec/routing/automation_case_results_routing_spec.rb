require "spec_helper"

describe AutomationCaseResultsController do
  describe "routing" do

    it "routes to #index" do
      get("/automation_case_results").should route_to("automation_case_results#index")
    end

    it "routes to #new" do
      get("/automation_case_results/new").should route_to("automation_case_results#new")
    end

    it "routes to #show" do
      get("/automation_case_results/1").should route_to("automation_case_results#show", :id => "1")
    end

    it "routes to #edit" do
      get("/automation_case_results/1/edit").should route_to("automation_case_results#edit", :id => "1")
    end

    it "routes to #create" do
      post("/automation_case_results").should route_to("automation_case_results#create")
    end

    it "routes to #update" do
      put("/automation_case_results/1").should route_to("automation_case_results#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/automation_case_results/1").should route_to("automation_case_results#destroy", :id => "1")
    end

  end
end
