require "spec_helper"

describe Admin::ProjectCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/project_categories").should route_to("admin/project_categories#index")
    end

    it "routes to #new" do
      get("/admin/project_categories/new").should route_to("admin/project_categories#new")
    end

    it "routes to #show" do
      get("/admin/project_categories/1").should route_to("admin/project_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/project_categories/1/edit").should route_to("admin/project_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/project_categories").should route_to("admin/project_categories#create")
    end

    it "routes to #update" do
      put("/admin/project_categories/1").should route_to("admin/project_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/project_categories/1").should route_to("admin/project_categories#destroy", :id => "1")
    end

  end
end
