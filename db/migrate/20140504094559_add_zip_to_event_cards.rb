class AddZipToEventCards < ActiveRecord::Migration[4.2]
  def change
    add_column :event_cards, :zip, :string
  end
end
