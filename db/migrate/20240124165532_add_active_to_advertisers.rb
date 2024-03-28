class AddActiveToAdvertisers < ActiveRecord::Migration[7.1]
  def change
    add_column :advertisers, :active, :boolean
  end
end
