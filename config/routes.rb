Rails.application.routes.draw do
  get "contact/index"
  get "pricing/index"
  get "process/index"
  get "founder_letter/index"
  resource :session
  resources :passwords, param: :token
  resources :blogs
  # Not "/404": the static file server would answer that with public/404.html.
  get "not_found", to: "errors#not_found"
  root "home#index"
end
