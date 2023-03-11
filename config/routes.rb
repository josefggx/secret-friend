Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/locations', to: "locations#index"
  post '/locations', to: "locations#create"

  get '/workers', to: "workers#index"
  post '/workers', to: "workers#create"
end
