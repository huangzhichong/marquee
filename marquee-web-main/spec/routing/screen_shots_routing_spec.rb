require "spec_helper"

describe ScreenShotsController do
  describe "routing" do

    it "routes to #index" do
      get("/screen_shots").should route_to("screen_shots#index")
    end

    it "routes to #new" do
      get("/screen_shots/new").should route_to("screen_shots#new")
    end

    it "routes to #show" do
      get("/screen_shots/1").should route_to("screen_shots#show", :id => "1")
    end

    it "routes to #edit" do
      get("/screen_shots/1/edit").should route_to("screen_shots#edit", :id => "1")
    end

    it "routes to #create" do
      post("/screen_shots").should route_to("screen_shots#create")
    end

    it "routes to #update" do
      put("/screen_shots/1").should route_to("screen_shots#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/screen_shots/1").should route_to("screen_shots#destroy", :id => "1")
    end

  end
end
