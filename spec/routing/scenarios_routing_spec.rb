require 'spec_helper'

describe 'ScenariosController' do
  describe 'routing' do

    xit 'routes to #index' do
      get('/scenarios').should route_to('scenarios#index')
    end

    xit 'routes to #new' do
      get('/scenarios/new').should route_to('scenarios#new')
    end

    it 'routes to #show' do
      get('/scenarios/1').should route_to('application#render_client', id: '1')
    end

    xit 'routes to #edit' do
      get('/scenarios/1/edit').should route_to('scenarios#edit', :id => '1')
    end

    xit 'routes to #create' do
      post('/scenarios').should route_to('scenarios#create')
    end

    xit 'routes to #update' do
      put('/scenarios/1').should route_to('scenarios#update', :id => '1')
    end

    xit 'routes to #destroy' do
      delete('/scenarios/1').should route_to('scenarios#destroy', :id => '1')
    end

  end
end
