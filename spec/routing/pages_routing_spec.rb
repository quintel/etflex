require 'spec_helper'

describe PagesController, 'routing' do
  it 'routes / to pages#root' do
    get('/root').should route_to('pages#root')
  end
end
