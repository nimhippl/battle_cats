Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'

  # auth
  get "/login", to: "auth#new"
  post "/login", to: "auth#create"
  get "/signup", to: "auth#signup"
  post "/signup", to: "users#create"
  get "/logout", to: "auth#destroy"



  get "/info", to: "info#index"


end
