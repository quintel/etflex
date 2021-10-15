require 'rails_helper'

describe 'ScenariosController' do
  describe 'routing' do

    it 'does not route to scenarios at the top level' do
      get('/with/1').should_not be_routable
    end

    it 'does not route to #index' do
      get('/scenes/1337/with').should_not be_routable
    end

    it 'routes to #show' do
      get('/scenes/1337/with/1').should \
        route_to('scenarios#show', scene_id: '1337', id: '1')
    end

    it 'does not route to #edit' do
      get('/scenes/1337/with/1/edit').should_not be_routable
    end

    it 'routes creation to #update' do
      post('/scenes/1337/with/42').should \
        route_to('scenarios#update', scene_id: '1337', id: '42')
    end

    it 'routes to #update' do
      put('/scenes/1337/with/1').should \
        route_to('scenarios#update', scene_id: '1337', id: '1')
    end

    it 'does not route to #destroy' do
      delete('/scenes/1337/with/1').should_not be_routable
    end

  end
end
