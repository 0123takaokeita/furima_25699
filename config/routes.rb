Rails.application.routes.draw do
  get 'items/new'
  devise_for :users
  resources :items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
