Rails.application.routes.draw do
  devise_for :admins
  resources :tags
  resources :expenses
  get 'welcome/index'
  root 'welcome#index'
end
