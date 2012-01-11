require "spec_helper"

describe CiMappingsController do
  describe "routing" do

    it "routes to #index" do
      get("/ci_mappings").should route_to("ci_mappings#index")
    end

    it "routes to #new" do
      get("/ci_mappings/new").should route_to("ci_mappings#new")
    end

    it "routes to #show" do
      get("/ci_mappings/1").should route_to("ci_mappings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/ci_mappings/1/edit").should route_to("ci_mappings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/ci_mappings").should route_to("ci_mappings#create")
    end

    it "routes to #update" do
      put("/ci_mappings/1").should route_to("ci_mappings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/ci_mappings/1").should route_to("ci_mappings#destroy", :id => "1")
    end

  end
end
