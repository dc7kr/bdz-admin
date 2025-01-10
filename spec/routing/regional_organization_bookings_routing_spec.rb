require 'rails_helper'

RSpec.describe RegionalOrganizationBookingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/regional_organization_bookings').to route_to('regional_organization_bookings#index')
    end

    it 'routes to #new' do
      expect(get: '/regional_organization_bookings/new').to route_to('regional_organization_bookings#new')
    end

    it 'routes to #show' do
      expect(get: '/regional_organization_bookings/1').to route_to('regional_organization_bookings#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/regional_organization_bookings/1/edit').to route_to('regional_organization_bookings#edit',
                                                                        id: '1')
    end

    it 'routes to #create' do
      expect(post: '/regional_organization_bookings').to route_to('regional_organization_bookings#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/regional_organization_bookings/1').to route_to('regional_organization_bookings#update',
                                                                   id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/regional_organization_bookings/1').to route_to('regional_organization_bookings#destroy',
                                                                      id: '1')
    end
  end
end
