Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "static_pages/home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    post "/search", to: "groups#search"
    post "/add_member", to: "groups#add_member"
    resources :users, except: :index do
      member do
        get :following, :followers
      end
    end
    resources :groups
    resources :reports, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
    namespace :admin do
      resources :users ,only: [:index] do
        patch  "/active_leader", to: "users#active_leader"
      end
    end
    resources :tasks
  end
end
