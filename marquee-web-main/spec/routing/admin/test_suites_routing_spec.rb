require "spec_helper"

describe Admin::TestSuitesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/test_suites").should route_to("admin/test_suites#index")
    end

    it "routes to #new" do
      get("/admin/test_suites/new").should route_to("admin/test_suites#new")
    end

    it "routes to #show" do
      get("/admin/test_suites/1").should route_to("admin/test_suites#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/test_suites/1/edit").should route_to("admin/test_suites#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/test_suites").should route_to("admin/test_suites#create")
    end

    it "routes to #update" do
      put("/admin/test_suites/1").should route_to("admin/test_suites#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/test_suites/1").should route_to("admin/test_suites#destroy", :id => "1")
    end

  end
end
