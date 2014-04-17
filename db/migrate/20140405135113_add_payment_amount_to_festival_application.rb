class AddPaymentAmountToFestivalApplication < ActiveRecord::Migration
  def change
    add_column :festival_applications, :amount, :double
  end
end
