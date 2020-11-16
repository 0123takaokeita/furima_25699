Rails.application.routes.draw do
  get 'comments/create'
  get 'transactions/index'
  root to: "items#index"
  get 'items/new'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  devise_scope :user do
    get 'users/new_address_preset', to: 'users/registrations#new_address_preset'
    post 'users/create_address_preset', to: 'users/registrations#create_address_preset'
  end
  resources :items do
    resources :transactions, only: [:index, :create]
    resources :comments, only: :create     # 追記
  end
end
