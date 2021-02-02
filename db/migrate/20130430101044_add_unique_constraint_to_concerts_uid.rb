class AddUniqueConstraintToConcertsUid < ActiveRecord::Migration[4.2]
  def change
	add_index :concerts, :uid, :unique => true
  end
end
