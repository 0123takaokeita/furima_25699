Rails.application.routes.draw do
  get 'comments/create'
  get 'transactions/index'
  root to: "items#index"
  get 'items/new'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  resources :items do
    resources :transactions, only: [:index, :create]
    resources :comments, only: :create     # 追記
  end
end
