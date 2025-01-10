require 'rails_helper'

RSpec.describe MagazineAdvertsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/magazine_adverts').to route_to('magazine_adverts#index')
    end

    it 'routes to #new' do
      expect(get: '/magazine_adverts/new').to route_to('magazine_adverts#new')
    end

    it 'routes to #show' do
      expect(get: '/magazine_adverts/1').to route_to('magazine_adverts#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/magazine_adverts/1/edit').to route_to('magazine_adverts#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/magazine_adverts').to route_to('magazine_adverts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/magazine_adverts/1').to route_to('magazine_adverts#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/magazine_adverts/1').to route_to('magazine_adverts#destroy', id: '1')
    end
  end
end
