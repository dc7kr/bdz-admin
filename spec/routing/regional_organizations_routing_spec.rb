require "rails_helper"

RSpec.describe RegionalOrganizationsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/regional_organizations").to route_to("regional_organizations#index")
    end

    it "routes to #new" do
      expect(:get => "/regional_organizations/new").to route_to("regional_organizations#new")
    end

    it "routes to #show" do
      expect(:get => "/regional_organizations/1").to route_to("regional_organizations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/regional_organizations/1/edit").to route_to("regional_organizations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/regional_organizations").to route_to("regional_organizations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/regional_organizations/1").to route_to("regional_organizations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/regional_organizations/1").to route_to("regional_organizations#destroy", :id => "1")
    end

  end
end
