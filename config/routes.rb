Rails.application.routes.draw do
  resources :expenses
  get 'welcome/index'
  root 'welcome#index'
end
