class CreateFeatureRequests < ActiveRecord::Migration
  def change
    create_table :feature_requests do |t|
      t.string :title
      t.string :description
      t.integer :priority

      t.timestamps
    end
  end
end
