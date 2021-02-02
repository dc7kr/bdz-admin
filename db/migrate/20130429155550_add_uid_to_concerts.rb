class AddUidToConcerts < ActiveRecord::Migration[4.2]
  def change
    add_column :concerts, :uid, :string
  end
end
