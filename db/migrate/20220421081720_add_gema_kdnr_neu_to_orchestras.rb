class AddGemaKdnrNeuToOrchestras < ActiveRecord::Migration[5.2]
  def change
    add_column :orchestras, :gema_kdnr_new, :string
  end
end
