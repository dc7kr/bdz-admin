class AddStatusToFeatureRequests < ActiveRecord::Migration
  def change
    add_column :feature_requests, :status, :string
  end
end
