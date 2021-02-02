class AddStatusToFeatureRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :feature_requests, :status, :string
  end
end
