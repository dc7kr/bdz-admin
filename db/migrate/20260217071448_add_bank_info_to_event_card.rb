class AddBankInfoToEventCard < ActiveRecord::Migration[7.2]
  def change
    add_column :event_cards, :iban, :string
    add_column :event_cards, :bic, :string
    add_column :event_cards, :account_owner, :string
    add_column :event_cards, :bank_name, :string
  end
end
