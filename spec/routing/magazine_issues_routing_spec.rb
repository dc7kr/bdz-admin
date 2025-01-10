require 'rails_helper'

RSpec.describe MagazineIssuesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/magazine_issues').to route_to('magazine_issues#index')
    end

    it 'routes to #new' do
      expect(get: '/magazine_issues/new').to route_to('magazine_issues#new')
    end

    it 'routes to #show' do
      expect(get: '/magazine_issues/1').to route_to('magazine_issues#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/magazine_issues/1/edit').to route_to('magazine_issues#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/magazine_issues').to route_to('magazine_issues#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/magazine_issues/1').to route_to('magazine_issues#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/magazine_issues/1').to route_to('magazine_issues#destroy', id: '1')
    end
  end
end
