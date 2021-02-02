class AddNewFieldsToDistinction < ActiveRecord::Migration[4.2]
  def change
	add_column :distinctions, :gold_needles, :integer
	add_column :distinctions, :silver_needles, :integer
	add_column :distinctions, :national_needles, :integer
	remove_column :distinctions, :needles
  end
end
