class AddZipToEventCards < ActiveRecord::Migration
  def change
    add_column :event_cards, :zip, :string
  end
end
