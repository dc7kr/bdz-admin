class RenameCommentInConcerts < ActiveRecord::Migration[4.2]
  def up
    rename_column :concerts, :bemerkung, :comment
  end

  def down
    rename_column :concerts, :comment, :bemerkung
  end
end
