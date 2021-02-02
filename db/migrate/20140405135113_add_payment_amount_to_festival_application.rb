class AddPaymentAmountToFestivalApplication < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :amount, :double
  end
end
