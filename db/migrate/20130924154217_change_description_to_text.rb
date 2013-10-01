class ChangeDescriptionToText < ActiveRecord::Migration
  def up
     change_column :feature_requests, :description, :text
  end

  def down
  end
end
