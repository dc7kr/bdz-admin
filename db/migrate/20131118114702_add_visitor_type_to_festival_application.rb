class AddVisitorTypeToFestivalApplication < ActiveRecord::Migration
  def change
    add_column :festival_applications, :visitor_type, :string
  end
end
