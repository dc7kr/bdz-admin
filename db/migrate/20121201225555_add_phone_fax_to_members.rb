class AddPhoneFaxToMembers < ActiveRecord::Migration[4.2]
  def change
    add_column :members, :telefon, :string

    add_column :members, :fax, :string

  end
end
