Rails.application.routes.draw do
  get "founder_letter/index"
  get "about/index"
  resource :session
  resources :passwords, param: :token
  resources :blogs
  root "home#index"
end
