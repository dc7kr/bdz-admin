require "rails_helper"

RSpec.describe UrlCategoriesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/url_categories").to route_to("url_categories#index")
    end

    it "routes to #new" do
      expect(:get => "/url_categories/new").to route_to("url_categories#new")
    end

    it "routes to #show" do
      expect(:get => "/url_categories/1").to route_to("url_categories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/url_categories/1/edit").to route_to("url_categories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/url_categories").to route_to("url_categories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/url_categories/1").to route_to("url_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/url_categories/1").to route_to("url_categories#destroy", :id => "1")
    end

  end
end
