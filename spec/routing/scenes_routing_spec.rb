require 'spec_helper'

describe 'ScenesController' do
  describe 'routing' do

    xit 'routes to #index' do
      get('/scenes').should route_to('scenes#index')
    end

    xit 'routes to #new' do
      get('/scenes/new').should route_to('scenes#new')
    end

    it 'routes to #show' do
      get('/scenes/1').should route_to('application#scene', id: '1')
    end

    xit 'routes to #edit' do
      get('/scenes/1/edit').should route_to('scenes#edit', :id => '1')
    end

    xit 'routes to #create' do
      post('/scenes').should route_to('scenes#create')
    end

    xit 'routes to #update' do
      put('/scenes/1').should route_to('scenes#update', :id => '1')
    end

    xit 'routes to #destroy' do
      delete('/scenes/1').should route_to('scenes#destroy', :id => '1')
    end

  end
end
