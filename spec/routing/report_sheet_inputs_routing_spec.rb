require "rails_helper"

RSpec.describe ReportSheetInputsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/report_sheet_inputs").to route_to("report_sheet_inputs#index")
    end

    it "routes to #new" do
      expect(:get => "/report_sheet_inputs/new").to route_to("report_sheet_inputs#new")
    end

    it "routes to #show" do
      expect(:get => "/report_sheet_inputs/1").to route_to("report_sheet_inputs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/report_sheet_inputs/1/edit").to route_to("report_sheet_inputs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/report_sheet_inputs").to route_to("report_sheet_inputs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/report_sheet_inputs/1").to route_to("report_sheet_inputs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/report_sheet_inputs/1").to route_to("report_sheet_inputs#destroy", :id => "1")
    end

  end
end
