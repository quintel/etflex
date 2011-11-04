require 'spec_helper'

describe 'ModulesController' do
  describe 'routing' do

    xit 'routes to #index' do
      get('/modules').should route_to('modules#index')
    end

    xit 'routes to #new' do
      get('/modules/new').should route_to('modules#new')
    end

    it 'routes to #show' do
      get('/modules/1').should route_to('application#render_client', id: '1')
    end

    xit 'routes to #edit' do
      get('/modules/1/edit').should route_to('modules#edit', :id => '1')
    end

    xit 'routes to #create' do
      post('/modules').should route_to('modules#create')
    end

    xit 'routes to #update' do
      put('/modules/1').should route_to('modules#update', :id => '1')
    end

    xit 'routes to #destroy' do
      delete('/modules/1').should route_to('modules#destroy', :id => '1')
    end

  end
end
