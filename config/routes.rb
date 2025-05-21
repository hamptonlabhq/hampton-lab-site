Rails.application.routes.draw do
  get "contact/index"
  get "founder_letter/index"
  get "about/index"
  resource :session
  resources :passwords, param: :token
  resources :blogs
  root "home#index"
end
