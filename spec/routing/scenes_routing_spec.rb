require 'spec_helper'

describe 'ScenesController' do
  describe 'routing' do

    it 'routes to #index' do
      get('/scenes').should route_to('scenes#index')
    end

    it 'routes to #show' do
      get('/scenes/1').should route_to('scenes#show', id: '1')
    end

    it 'does not route to #edit' do
      get('/scenes/1/edit').should_not be_routable
    end

    it 'does not route to #create' do
      post('/scenes').should_not be_routable
    end

    it 'does not route to #update' do
      put('/scenes/1').should_not be_routable
    end

    it 'does not route to #destroy' do
      delete('/scenes/1').should_not be_routable
    end

  end
end
