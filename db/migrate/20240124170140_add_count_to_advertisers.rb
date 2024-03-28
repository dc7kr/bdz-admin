class AddCountToAdvertisers < ActiveRecord::Migration[7.1]
  def change
    add_column :advertisers, :magazines, :integer
  end
end
