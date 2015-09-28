require "rails_helper"

RSpec.describe PersonMembersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/person_members").to route_to("person_members#index")
    end

    it "routes to #new" do
      expect(:get => "/person_members/new").to route_to("person_members#new")
    end

    it "routes to #show" do
      expect(:get => "/person_members/1").to route_to("person_members#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/person_members/1/edit").to route_to("person_members#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/person_members").to route_to("person_members#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/person_members/1").to route_to("person_members#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/person_members/1").to route_to("person_members#destroy", :id => "1")
    end

  end
end
