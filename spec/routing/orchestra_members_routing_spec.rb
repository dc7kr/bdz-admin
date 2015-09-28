require "rails_helper"

RSpec.describe OrchestraMembersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/orchestra_members").to route_to("orchestra_members#index")
    end

    it "routes to #new" do
      expect(:get => "/orchestra_members/new").to route_to("orchestra_members#new")
    end

    it "routes to #show" do
      expect(:get => "/orchestra_members/1").to route_to("orchestra_members#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/orchestra_members/1/edit").to route_to("orchestra_members#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/orchestra_members").to route_to("orchestra_members#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/orchestra_members/1").to route_to("orchestra_members#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/orchestra_members/1").to route_to("orchestra_members#destroy", :id => "1")
    end

  end
end
