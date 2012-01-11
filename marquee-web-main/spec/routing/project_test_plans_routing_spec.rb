require "spec_helper"

describe ProjectTestPlansController do
  describe "routing" do

    it "routes to #index" do
      get("/project_test_plans").should route_to("project_test_plans#index")
    end

    it "routes to #new" do
      get("/project_test_plans/new").should route_to("project_test_plans#new")
    end

    it "routes to #show" do
      get("/project_test_plans/1").should route_to("project_test_plans#show", :id => "1")
    end

    it "routes to #edit" do
      get("/project_test_plans/1/edit").should route_to("project_test_plans#edit", :id => "1")
    end

    it "routes to #create" do
      post("/project_test_plans").should route_to("project_test_plans#create")
    end

    it "routes to #update" do
      put("/project_test_plans/1").should route_to("project_test_plans#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/project_test_plans/1").should route_to("project_test_plans#destroy", :id => "1")
    end

  end
end
