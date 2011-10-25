require "spec_helper"

describe ScenariosController do
  describe "routing" do

    it "routes to #index" do
      get("/scenarios").should route_to("scenarios#index")
    end

    it "routes to #new" do
      get("/scenarios/new").should route_to("scenarios#new")
    end

    it "routes to #show" do
      get("/scenarios/1").should route_to("scenarios#show", :id => "1")
    end

    it "routes to #edit" do
      get("/scenarios/1/edit").should route_to("scenarios#edit", :id => "1")
    end

    it "routes to #create" do
      post("/scenarios").should route_to("scenarios#create")
    end

    it "routes to #update" do
      put("/scenarios/1").should route_to("scenarios#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/scenarios/1").should route_to("scenarios#destroy", :id => "1")
    end

  end
end
