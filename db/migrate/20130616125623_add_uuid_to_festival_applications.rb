class AddUuidToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :uuid, :string
    execute <<-SQL
      UPDATE festival_applications set uuid=UUID()
    SQL
  end
end
