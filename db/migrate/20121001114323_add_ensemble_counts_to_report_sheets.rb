class AddEnsembleCountsToReportSheets < ActiveRecord::Migration
  def change
    add_column :report_sheets, :child_ens, :integer, :default =>0, :null=>false
    add_column :report_sheets, :youth_ens, :integer, :default =>0, :null=>false
    add_column :report_sheets, :adult_ens, :integer, :default =>0, :null=>false
    add_column :report_sheets, :senior_ens, :integer, :default =>0, :null=>false
    add_column :report_sheets, :chamber_ens, :integer, :default =>0, :null=>false
    add_column :report_sheets, :other_ens, :integer, :default =>0, :null=>false

  end
end
