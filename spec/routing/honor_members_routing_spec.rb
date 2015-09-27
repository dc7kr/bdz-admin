require "rails_helper"

RSpec.describe HonorMembersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/honor_members").to route_to("honor_members#index")
    end

    it "routes to #new" do
      expect(:get => "/honor_members/new").to route_to("honor_members#new")
    end

    it "routes to #show" do
      expect(:get => "/honor_members/1").to route_to("honor_members#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/honor_members/1/edit").to route_to("honor_members#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/honor_members").to route_to("honor_members#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/honor_members/1").to route_to("honor_members#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/honor_members/1").to route_to("honor_members#destroy", :id => "1")
    end

  end
end
