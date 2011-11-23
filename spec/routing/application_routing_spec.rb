require 'spec_helper'

describe ApplicationController, 'routing' do
  it 'routes / to render_client' do
    get('/').should route_to('application#render_client')
  end

  it 'routes /en to render_client' do
    get('/en').should route_to('application#render_client', locale: 'en')
  end

  it 'routes /nl to render_client' do
    get('/nl').should route_to('application#render_client', locale: 'nl')
  end

  it 'routes /sanity to render_client' do
    get('/sanity').should route_to('application#render_client')
  end

  it 'routes /etlite to render_client' do
    get('/etlite').should route_to('application#render_client')
  end

  it 'routes /scenes/:id to scene' do
    get('/scenes/1').should route_to('application#scene', id: '1')
  end

  it 'should not route /scenes' do
    get('/scenes').should_not be_routable
  end
end
