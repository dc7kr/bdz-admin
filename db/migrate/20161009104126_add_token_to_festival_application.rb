class AddTokenToFestivalApplication < ActiveRecord::Migration
  def change
    add_column :festival_applications, :token, :string
  end
end
