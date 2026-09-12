class AddTitleToHonorMember < ActiveRecord::Migration[7.2]
  def change
    add_column :honor_members, :title, :string
  end
end
