class AddNameToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.string :name
    end
  end
end
