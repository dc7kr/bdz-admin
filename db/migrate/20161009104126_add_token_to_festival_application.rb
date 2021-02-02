class AddTokenToFestivalApplication < ActiveRecord::Migration[4.2]
  def change
    add_column :festival_applications, :token, :string
  end
end
