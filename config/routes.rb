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
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :groups
    resources :reports, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
  end
end
