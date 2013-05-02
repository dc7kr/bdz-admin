class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :account
      t.string :bic
      t.integer :contact_id

      t.timestamps
    end
  end
end
