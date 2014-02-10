class AddPaymentStatusToFestivalApplications < ActiveRecord::Migration
  def change
    add_column :festival_applications, :payment_status, "ENUM('N', 'P', 'F','S')",:default=>"N"
  end
end
