require 'spec_helper'

describe PagesController, 'routing' do
  it 'routes / to pages#root' do
    get('/').should route_to('pages#root')
  end

  it 'routes PUT /me to pages#update_username' do
    put('/me').should route_to('pages#update_username')
  end
end
