require 'spec_helper'

describe 'ScenariosController' do
  describe 'routing' do

    it 'does not route to scenarios at the top level' do
      get('/scenarios/1').should_not be_routable
    end

    it 'does not route to #index' do
      get('/scenes/1337/scenarios').should_not be_routable
    end

    it 'routes to #show using /with/...' do
      get('/scenes/1337/with/1').should \
        route_to('scenarios#show', scene_id: '1337', id: '1')
    end

    it 'routes to #show using /scenarios/...' do
      get('/scenes/1337/scenarios/1').should \
        route_to('scenarios#show', scene_id: '1337', id: '1')
    end

    it 'does not route to #edit' do
      get('/scenes/1337/scenarios/1/edit').should_not be_routable
    end

    it 'routes to #create' do
      post('/scenes/1337/scenarios').should \
        route_to('scenarios#create', scene_id: '1337')
    end

    it 'does not route to #update' do
      put('/scenes/1337/scenarios/1').should_not be_routable
    end

    it 'does not route to #destroy' do
      delete('/scenes/1337/scenarios/1').should_not be_routable
    end

  end
end
