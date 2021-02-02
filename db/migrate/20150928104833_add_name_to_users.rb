class AddNameToUsers < ActiveRecord::Migration[4.2]
  def self.up
    change_table(:users) do |t|
      t.string :name
    end
  end
end
