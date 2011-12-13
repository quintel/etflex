require 'spec_helper'

describe ApplicationController, 'routing' do
  it 'routes / to render_client' do
    get('/').should route_to('application#render_client')
  end

  it 'routes /en to render_client' do
    pending 'Pending re-addition of language swapping' do
      get('/en').should route_to('application#render_client', locale: 'en')
    end
  end

  it 'routes /nl to render_client' do
    pending 'Pending re-addition of language swapping' do
      get('/nl').should route_to('application#render_client', locale: 'nl')
    end
  end

  it 'routes /scenes/:id to scene' do
    get('/scenes/1').should route_to('application#scene', id: '1')
  end

  it 'should not route /scenes' do
    get('/scenes').should_not be_routable
  end
end
