class AddUserToFeatureRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :feature_requests, :user_id, :integer
  end
end
