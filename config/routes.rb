# Routing configuration
Lines::Application.routes.draw do

  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'tags/:tag', to: 'articles#index', as: :tag

  resources :sessions

  resources :articles, only: [:index, :show] do
    get 'page/:page', action: :index, on: :collection
  end

  resources :short_articles, only: [:index, :show], controller: :articles do
    get 'page/:page', action: :index, on: :collection
  end

  # Admin namespace
  namespace :admin do
    resources :articles do
      get :autocomplete_tag_name, on: :collection
      post :toggle_publish
      post :toggle_feature
    end
    resources :authors
    resources :pictures, only: [:create, :update, :destroy]
    resources :users
    root :to => 'articles#index'
  end
  
  root :to => 'articles#index'

end
