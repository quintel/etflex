ETFlex::Application.routes.draw do

  resources :scenes, except: %w( new create edit update destroy ) do
    get  'with/:id', to: 'scenarios#show', as: :scenario
    post 'with/:id', to: 'scenarios#update'
    put  'with/:id', to: 'scenarios#update'
  end

  # Devise -------------------------------------------------------------------

  devise_for :users, :controllers => { omniauth_callbacks: "omniauth_callbacks", registrations: "users"} do
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

  root to: 'home#root'

end
