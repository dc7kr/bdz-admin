class AddCountryCodeToHochschulen< ActiveRecord::Migration
  def change
      add_column :hochschulen, :country_code, :string, :limit=>2
  end
end
