require "rails_helper"

RSpec.describe OrchestraContactsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/orchestra_contacts").to route_to("orchestra_contacts#index")
    end

    it "routes to #new" do
      expect(:get => "/orchestra_contacts/new").to route_to("orchestra_contacts#new")
    end

    it "routes to #show" do
      expect(:get => "/orchestra_contacts/1").to route_to("orchestra_contacts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/orchestra_contacts/1/edit").to route_to("orchestra_contacts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/orchestra_contacts").to route_to("orchestra_contacts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/orchestra_contacts/1").to route_to("orchestra_contacts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/orchestra_contacts/1").to route_to("orchestra_contacts#destroy", :id => "1")
    end

  end
end
