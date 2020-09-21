Rails.application.routes.draw do
  get 'transactions/index'
  root to: "items#index"
  get 'items/new'
  devise_for :users
  resources :items do
    resources :transactions, only: [:index, :create]
  end
end
