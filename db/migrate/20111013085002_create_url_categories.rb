class CreateUrlCategories < ActiveRecord::Migration
  def change
    create_table :url_categories do |t|
      t.references, :parent
      t.bool, :leaf
      t.bool, :hascountry
      t.string :description

      t.timestamps
    end
  end
end
