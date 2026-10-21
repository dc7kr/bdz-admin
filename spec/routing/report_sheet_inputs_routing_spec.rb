require 'rails_helper'

RSpec.describe ReportSheetInputsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/report_sheet_inputs').to route_to('report_sheet_inputs#index')
    end

    it 'routes to #new' do
      expect(get: '/report_sheet_inputs/new').to route_to('report_sheet_inputs#new')
    end

    it 'routes to #show' do
      expect(get: '/report_sheet_inputs/1').to route_to('report_sheet_inputs#show', id: '1')
    end

    it 'routes to #lockdown via POST' do
      expect(post: '/report_sheet_inputs/lockdown').to route_to('report_sheet_inputs#lockdown')
    end

    it 'does not route lockdown via GET' do
      expect(get: '/report_sheet_inputs/lockdown').not_to route_to('report_sheet_inputs#lockdown')
    end

    it 'does not route to #edit' do
      expect(get: '/report_sheet_inputs/1/edit').not_to be_routable
    end

    it 'does not route to #create' do
      expect(post: '/report_sheet_inputs').not_to be_routable
    end

    it 'does not route to #update' do
      expect(put: '/report_sheet_inputs/1').not_to be_routable
      expect(patch: '/report_sheet_inputs/1').not_to be_routable
    end

    it 'routes to #destroy' do
      expect(delete: '/report_sheet_inputs/1').to route_to('report_sheet_inputs#destroy', id: '1')
    end
  end
end
