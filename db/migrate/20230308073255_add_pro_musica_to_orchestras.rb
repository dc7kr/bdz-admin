class AddProMusicaToOrchestras < ActiveRecord::Migration[5.2]
  def change
    add_column :orchestras, :promusica, :date
  end
end
