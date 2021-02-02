class AddCountryCodeToHochschulen< ActiveRecord::Migration[4.2]
  def change
      add_column :hochschulen, :country_code, :string, :limit=>2
  end
end
