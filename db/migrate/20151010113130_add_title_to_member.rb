class AddTitleToMember < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :title, :string
  end
end
