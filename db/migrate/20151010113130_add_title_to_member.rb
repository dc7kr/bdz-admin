class AddTitleToMember < ActiveRecord::Migration
  def change
    add_column :members, :title, :string
  end
end
