require "spec_helper"

describe TeamMembersController do
  describe "routing" do

    it "routes to #index" do
      get("/team_members").should route_to("team_members#index")
    end

    it "routes to #new" do
      get("/team_members/new").should route_to("team_members#new")
    end

    it "routes to #show" do
      get("/team_members/1").should route_to("team_members#show", :id => "1")
    end

    it "routes to #edit" do
      get("/team_members/1/edit").should route_to("team_members#edit", :id => "1")
    end

    it "routes to #create" do
      post("/team_members").should route_to("team_members#create")
    end

    it "routes to #update" do
      put("/team_members/1").should route_to("team_members#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/team_members/1").should route_to("team_members#destroy", :id => "1")
    end

  end
end
