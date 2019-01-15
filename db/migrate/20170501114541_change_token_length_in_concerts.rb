class ChangeTokenLengthInConcerts < ActiveRecord::Migration
  def change
    change_column :concerts, :token, :string
  end
end
