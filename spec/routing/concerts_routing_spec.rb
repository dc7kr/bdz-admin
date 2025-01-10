require 'rails_helper'

RSpec.describe ConcertsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/concerts').to route_to('concerts#index')
    end

    it 'routes to #new' do
      expect(get: '/concerts/new').to route_to('concerts#new')
    end

    it 'routes to #show' do
      expect(get: '/concerts/1').to route_to('concerts#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/concerts/1/edit').to route_to('concerts#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/concerts').to route_to('concerts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/concerts/1').to route_to('concerts#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/concerts/1').to route_to('concerts#destroy', id: '1')
    end
  end
end
