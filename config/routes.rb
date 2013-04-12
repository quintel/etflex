ETFlex::Application.routes.draw do

  resources :scenes, except: %w( new create edit update destroy ) do
    get  'with/:id', to: 'scenarios#show', as: :scenario
    post 'with/:id', to: 'scenarios#update'
    put  'with/:id', to: 'scenarios#update'

    member { get 'fresh' }
  end

  # High scoring scenarios for the high scores list.
  get 'scenes/:scene_id/scenarios/since/:days', to: 'scenarios#since'

  # Devise -------------------------------------------------------------------

  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks', registrations: 'users' }

  devise_scope :user do
    get '/hello',   to: 'devise/sessions#new'
    get '/goodbye', to: 'devise/sessions#destroy'
  end

  # Update username via JSON.
  put '/me', to: 'pages#update_username'

  # Backstage and Administration ---------------------------------------------

  namespace :backstage do
    resources :scenes do
      resources :props,  controller: 'scene_props',  except: :show
    end

    get '/', to: redirect('/backstage/scenes')
  end

  # Default Path -------------------------------------------------------------

  # A temporary page for viewing / testing what will become the root page.
  get '/lang/:locale', to: 'pages#lang'

  get '/supported_browsers', to: 'pages#supported_browsers'

  root to: 'pages#root'

end
