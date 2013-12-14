class RemoveCountryIdColumn < ActiveRecord::Migration

  def drop_if_exists(table,col)
    if column_exists? table,col then 
      remove_column table,col 
    end
  end

  def up

    drop_if_exists :festival_applications,:country_id 

    if column_exists? :bundeslaender, :country_id then
      ActiveRecord::Base.connection.execute <<-EOS
        ALTER TABLE  bundeslaender DROP FOREIGN KEY bundeslaender_ibfk_2
      EOS
    
      remove_index(:bundeslaender, name: "country")
      remove_column :bundeslaender, :country_id
    end

    if column_exists? :bundeslaender, :country_id then
      ActiveRecord::Base.connection.execute <<-EOS
        ALTER TABLE  urls DROP FOREIGN KEY urls_ibfk_7
      EOS
      remove_index(:urls , name: "country")
      remove_column :urls, :country_id
    end

    drop_if_exists :concerts, :country_id

    if column_exists? :festivals,:country_id 

      remove_iundex(:festivals, name: "land")
      remove_column :festivals, :country_id
    end
    drop_if_exists :contact_people, :country_id
    drop_if_exists :contacts, :country_id

    if column_exists?(:hochschulen, :country_id) then
      ActiveRecord::Base.connection.execute <<-EOS
        ALTER TABLE  hochschulen DROP FOREIGN KEY  hochschulen_ibfk_1
      EOS
      remove_index(:festivals, name: "land")
      remove_column :hochschulen, :country_id
    end
  end

  def down
  end
end
