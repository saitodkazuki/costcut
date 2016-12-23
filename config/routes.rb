Rails.application.routes.draw do
  resources :tags
  resources :expenses
  get 'welcome/index'
  root 'welcome#index'
end
