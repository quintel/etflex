require 'spec_helper'

describe ApplicationController, 'routing' do
  it 'routes / to home#root' do
    get('/').should route_to('home#root')
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
end
