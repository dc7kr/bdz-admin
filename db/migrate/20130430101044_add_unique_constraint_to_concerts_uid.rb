class AddUniqueConstraintToConcertsUid < ActiveRecord::Migration
  def change
	add_index :concerts, :uid, :unique => true
  end
end
