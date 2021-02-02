class ChangeDescriptionToText < ActiveRecord::Migration[4.2]
  def up
     change_column :feature_requests, :description, :text
  end

  def down
  end
end
