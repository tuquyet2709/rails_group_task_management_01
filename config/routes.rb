Rails.application.routes.draw do
  devise_for :users, skip: [:session, :password, :registration], controllers: { omniauth_callbacks: "omniauth_callbacks" }
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "static_pages/home"
    post "/add_member", to: "groups#add_member"
    delete "/remove_member", to: "groups#remove_member"
    post "/change_subtask", to: "tasks#change_subtask"
    devise_for :users, controllers: {
        confirmations: "confirmations" }, skip: [:omniauth_callbacks]
    resources :users, only: [:show, :edit, :update] do
      member do
        get :following, :followers
        match "search" => "users#search", via: [:get, :post], as: :search
      end
    end
    resources :groups do
      resources :tasks
      get "statistic", to: "tasks#statistic"
      member do
        match "search" => "groups#search", via: [:get, :post], as: :search
      end
    end
    resources :reports, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
    namespace :admin do
      resources :users, only: [:index] do
        patch "/active_leader", to: "users#active_leader"
      end
    end
    resources :tasks
  end
end
