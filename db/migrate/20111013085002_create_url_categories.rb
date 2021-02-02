class CreateUrlCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :url_categories do |t|
      t.references :parent
      t.boolean :leaf
      t.boolean :hascountry
      t.string :description

      t.timestamps
    end
  end
end
