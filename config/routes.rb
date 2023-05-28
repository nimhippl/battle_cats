Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'
  get "/battle", to: "battle#battle"

  # auth
  get "/login", to: "auth#new"
  post "/login", to: "auth#create"
  get "/signup", to: "auth#signup"
  post "/signup", to: "users#create"
  get "/logout", to: "auth#destroy"
  get "/final", to: "final#index"



  get "/info", to: "info#index"


end
