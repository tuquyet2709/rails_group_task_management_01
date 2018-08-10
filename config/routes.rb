Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "static_pages/home"
    post "/search", to: "groups#search"
    post "/add_member", to: "groups#add_member"
    delete "/remove_member", to: "groups#remove_member"
    post "/change_subtask", to: "tasks#change_subtask"
    # resources :users, except: :index do
    #   member do
    #     get :following, :followers
    #   end
    # end
    resources :groups do
      resources :tasks
      get "statistic", to: "tasks#statistic"
    end
    resources :reports, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
    namespace :admin do
      resources :users ,only: [:index] do
        patch  "/active_leader", to: "users#active_leader"
      end
    end
    resources :tasks
    devise_for :users, controllers: { confirmations: "confirmations" }
  end
end
