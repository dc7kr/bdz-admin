class AddGemaKdnrToOrchestra < ActiveRecord::Migration
  def change
    add_column :orchestras, :gema_kdnr, :integer
  end
end
