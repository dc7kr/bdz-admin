class CreateSubscribers < ActiveRecord::Migration[4.2]
  def change
    create_table :subscribers do |t|
      t.string :account
      t.string :bic
      t.integer :contact_id

      t.timestamps
    end
  end
end
