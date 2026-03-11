class SumupRefreshJob < ApplicationJob
  def perform
        client = CorikaSumup::Client.new
        CorikaSumup::Checkout.where(status: 'PENDING').each do |co|
          be_checkouts = client.get_checkouts(co.checkout_reference)

          if be_checkouts.length > 0
            be_co = be_checkouts.first
            co.status = be_co["status"]
            co.save
          end
        end
  end
end
