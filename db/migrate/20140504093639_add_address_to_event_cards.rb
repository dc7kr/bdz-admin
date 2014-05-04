class AddAddressToEventCards < ActiveRecord::Migration
  def change
    add_column :event_cards, :street, :string, :null=>true
    add_column :event_cards, :city, :string, :null=>true
    add_column :event_cards, :country_code, :string,:null=>true
    add_column :event_cards, :company, :string,:null=>true
    add_column :event_cards, :preferred_lang, :string, :null=>true
  end
end
