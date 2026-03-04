class AddTransactionCodeToEventCards < ActiveRecord::Migration[7.2]
  def change
    add_column :event_cards, :transaction_code, :string
  end
end
