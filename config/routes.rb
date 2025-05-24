Rails.application.routes.draw do
  get "contact/index"
  get "pricing/index"
  get "process/index"
  get "founder_letter/index"
  resource :session
  resources :passwords, param: :token
  resources :blogs
  root "home#index"
end
