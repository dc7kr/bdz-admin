require "rails_helper"

RSpec.describe ReportSheetsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/report_sheets").to route_to("report_sheets#index")
    end

    it "routes to #new" do
      expect(:get => "/report_sheets/new").to route_to("report_sheets#new")
    end

    it "routes to #show" do
      expect(:get => "/report_sheets/1").to route_to("report_sheets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/report_sheets/1/edit").to route_to("report_sheets#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/report_sheets").to route_to("report_sheets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/report_sheets/1").to route_to("report_sheets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/report_sheets/1").to route_to("report_sheets#destroy", :id => "1")
    end

  end
end
