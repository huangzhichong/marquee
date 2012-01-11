require "spec_helper"

describe TestRoundsController do
  describe "routing" do

    it "routes to #index" do
      get("/test_rounds").should route_to("test_rounds#index")
    end

    it "routes to #new" do
      get("/test_rounds/new").should route_to("test_rounds#new")
    end

    it "routes to #show" do
      get("/test_rounds/1").should route_to("test_rounds#show", :id => "1")
    end

    it "routes to #edit" do
      get("/test_rounds/1/edit").should route_to("test_rounds#edit", :id => "1")
    end

    it "routes to #create" do
      post("/test_rounds").should route_to("test_rounds#create")
    end

    it "routes to #update" do
      put("/test_rounds/1").should route_to("test_rounds#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/test_rounds/1").should route_to("test_rounds#destroy", :id => "1")
    end

  end
end
