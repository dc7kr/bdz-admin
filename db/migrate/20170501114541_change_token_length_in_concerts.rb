class ChangeTokenLengthInConcerts < ActiveRecord::Migration[4.2]
  def change
    change_column :concerts, :token, :string
  end
end
