require "spec_helper"

describe Admin::TestRoundsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/test_rounds").should route_to("admin/test_rounds#index")
    end

    it "routes to #new" do
      get("/admin/test_rounds/new").should route_to("admin/test_rounds#new")
    end

    it "routes to #show" do
      get("/admin/test_rounds/1").should route_to("admin/test_rounds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/test_rounds/1/edit").should route_to("admin/test_rounds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/test_rounds").should route_to("admin/test_rounds#create")
    end

    it "routes to #update" do
      put("/admin/test_rounds/1").should route_to("admin/test_rounds#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/test_rounds/1").should route_to("admin/test_rounds#destroy", :id => "1")
    end

  end
end
