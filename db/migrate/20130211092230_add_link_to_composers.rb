class AddLinkToComposers < ActiveRecord::Migration
  def change
    add_column :composers, :link, :string
  end
end
