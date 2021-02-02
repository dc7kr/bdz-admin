class AddGemaKdnrToOrchestra < ActiveRecord::Migration[4.2]
  def change
    add_column :orchestras, :gema_kdnr, :integer
  end
end
