class RemoveCardDataFromEventCards < ActiveRecord::Migration[4.2]
  def up
    remove_column :event_cards, :carddata
  end

  def down
    add_column :event_cards, :carddata, :string
  end
end
