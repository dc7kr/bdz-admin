require 'rails_helper'

RSpec.describe MemberAccountBookingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/member_account_bookings').to route_to('member_account_bookings#index')
    end

    it 'routes to #new' do
      expect(get: '/member_account_bookings/new').to route_to('member_account_bookings#new')
    end

    it 'routes to #show' do
      expect(get: '/member_account_bookings/1').to route_to('member_account_bookings#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/member_account_bookings/1/edit').to route_to('member_account_bookings#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/member_account_bookings').to route_to('member_account_bookings#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/member_account_bookings/1').to route_to('member_account_bookings#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/member_account_bookings/1').to route_to('member_account_bookings#destroy', id: '1')
    end
  end
end
