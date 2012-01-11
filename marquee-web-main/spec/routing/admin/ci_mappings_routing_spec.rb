require "spec_helper"

describe Admin::CiMappingsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/ci_mappings").should route_to("admin/ci_mappings#index")
    end

    it "routes to #new" do
      get("/admin/ci_mappings/new").should route_to("admin/ci_mappings#new")
    end

    it "routes to #show" do
      get("/admin/ci_mappings/1").should route_to("admin/ci_mappings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/ci_mappings/1/edit").should route_to("admin/ci_mappings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/ci_mappings").should route_to("admin/ci_mappings#create")
    end

    it "routes to #update" do
      put("/admin/ci_mappings/1").should route_to("admin/ci_mappings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/ci_mappings/1").should route_to("admin/ci_mappings#destroy", :id => "1")
    end

  end
end
