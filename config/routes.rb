ETFlex::Application.routes.draw do

  resources :scenes, except: %w( new create edit update destroy ) do
    resources :scenarios, path: 'with', only: %w( show create update )
  end

  # Devise -------------------------------------------------------------------

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" } do
    get '/hello',   to: 'devise/sessions#new'
    get '/goodbye', to: 'devise/sessions#destroy'
  end

  # Backstage and Administration ---------------------------------------------

  namespace :backstage do
    resources :inputs

    resources :scenes do
      resources :inputs, controller: 'scene_inputs', except: :show
      resources :props,  controller: 'scene_props',  except: :show
    end

    get '/', to: redirect('/backstage/scenes')
  end

  # Default Path -------------------------------------------------------------

  root to: 'scenes#index'

end
