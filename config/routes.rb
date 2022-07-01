Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users, only: [:create, :index] do
    resources :inboxes, only: [:index, :create, :show]
    resources :transactions, only: [:create, :index]
    member do
      get 'balance'
    end
  end

  resources :agencies, only: [:index] do
    resources :transfers, only: [:create]
    member do
      post 'claim'
      get 'transactions'
      

    end
  end
end
