require 'spec_helper'

describe PagesController, 'routing' do
  it 'routes PUT /me to pages#update_username' do
    put('/me').should route_to('pages#update_username')
  end
end
