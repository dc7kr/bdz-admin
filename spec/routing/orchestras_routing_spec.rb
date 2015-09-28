require "rails_helper"

RSpec.describe OrchestrasController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/orchestras").to route_to("orchestras#index")
    end

    it "routes to #new" do
      expect(:get => "/orchestras/new").to route_to("orchestras#new")
    end

    it "routes to #show" do
      expect(:get => "/orchestras/1").to route_to("orchestras#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/orchestras/1/edit").to route_to("orchestras#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/orchestras").to route_to("orchestras#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/orchestras/1").to route_to("orchestras#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/orchestras/1").to route_to("orchestras#destroy", :id => "1")
    end

  end
end
