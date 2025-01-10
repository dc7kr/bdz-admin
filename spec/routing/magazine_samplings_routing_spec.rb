require 'rails_helper'

RSpec.describe MagazineSamplingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/magazine_samplings').to route_to('magazine_samplings#index')
    end

    it 'routes to #new' do
      expect(get: '/magazine_samplings/new').to route_to('magazine_samplings#new')
    end

    it 'routes to #show' do
      expect(get: '/magazine_samplings/1').to route_to('magazine_samplings#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/magazine_samplings/1/edit').to route_to('magazine_samplings#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/magazine_samplings').to route_to('magazine_samplings#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/magazine_samplings/1').to route_to('magazine_samplings#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/magazine_samplings/1').to route_to('magazine_samplings#destroy', id: '1')
    end
  end
end
