class AddVisitorTypeToFestivalApplication < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :visitor_type, :string
  end
end
