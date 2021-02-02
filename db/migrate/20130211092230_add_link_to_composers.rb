class AddLinkToComposers < ActiveRecord::Migration[4.2]
  def change
    add_column :composers, :link, :string
  end
end
