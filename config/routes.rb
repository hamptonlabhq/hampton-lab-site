Rails.application.routes.draw do
  get "founder_letter/index"
  resource :session
  resources :passwords, param: :token
  resources :blogs
  root "home#index"
end
