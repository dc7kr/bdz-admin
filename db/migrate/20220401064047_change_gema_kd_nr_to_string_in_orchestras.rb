class ChangeGemaKdNrToStringInOrchestras < ActiveRecord::Migration[5.2]
  def change
    change_column :orchestras, :gema_kdnr, :string
  end
end
