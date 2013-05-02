class AddUidToConcerts < ActiveRecord::Migration
  def change
    add_column :concerts, :uid, :string
  end
end
