class AddPaymentMethodToEventCards < ActiveRecord::Migration[7.2]
  def change
    add_column :event_cards, :payment_method, :string
  end
end
