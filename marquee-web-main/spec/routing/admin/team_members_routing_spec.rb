require "spec_helper"

describe Admin::TeamMembersController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/team_members").should route_to("admin/team_members#index")
    end

    it "routes to #new" do
      get("/admin/team_members/new").should route_to("admin/team_members#new")
    end

    it "routes to #show" do
      get("/admin/team_members/1").should route_to("admin/team_members#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/team_members/1/edit").should route_to("admin/team_members#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/team_members").should route_to("admin/team_members#create")
    end

    it "routes to #update" do
      put("/admin/team_members/1").should route_to("admin/team_members#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/team_members/1").should route_to("admin/team_members#destroy", :id => "1")
    end

  end
end
