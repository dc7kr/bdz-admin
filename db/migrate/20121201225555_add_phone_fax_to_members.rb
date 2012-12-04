class AddPhoneFaxToMembers < ActiveRecord::Migration
  def change
    add_column :members, :telefon, :string

    add_column :members, :fax, :string

  end
end
