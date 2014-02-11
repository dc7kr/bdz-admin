class RemoveCardDataFromEventCards < ActiveRecord::Migration
  def up
    remove_column :event_cards, :carddata
  end

  def down
    add_column :event_cards, :carddata, :string
  end
end
