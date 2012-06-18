class CreateClassifieds < ActiveRecord::Migration
  def change
    create_table :classifieds do |t|

      t.timestamps
    end
  end
end
