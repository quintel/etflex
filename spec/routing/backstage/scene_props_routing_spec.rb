require 'spec_helper'

describe 'Backstage::SceneProps' do
  describe 'routing' do
    let(:prefix) { '/backstage/scenes/1337/props' }

    it 'routes to #index' do
      get(prefix).should \
        route_to('backstage/scene_props#index', scene_id: '1337')
    end

    it 'routes to #new' do
      get("#{ prefix }/new").should \
        route_to('backstage/scene_props#new', scene_id: '1337')
    end

    it 'should not route #show' do
      get("#{ prefix }/1").should_not be_routable
    end

    it 'routes to #edit' do
      get("#{ prefix }/1/edit").should \
        route_to('backstage/scene_props#edit', scene_id: '1337', id: '1')
    end

    it 'routes to #create' do
      post(prefix).should \
        route_to('backstage/scene_props#create', scene_id: '1337')
    end

    it 'routes to #update' do
      put("#{ prefix }/1").should \
        route_to('backstage/scene_props#update', scene_id: '1337', id: '1')
    end

    it 'routes to #destroy' do
      delete("#{ prefix }/1").should \
        route_to('backstage/scene_props#destroy', scene_id: '1337', id: '1')
    end

  end
end
