# frozen_string_literal: true

Rails.application.routes.draw do
  #   get 'reimbursements', to: "reimbursements#index"
  #   post 'reimbursements', to: "reimbursements#create"
  #   get 'reimbursements', to: "reimbursements#show"
  #   put 'reimbursements', to: "reimbursements#put"
  #   delete 'reimbursements', to: "reimbursements#delete"
  post '/signup/employee', to: 'users#create'
  post '/auth/login', to: 'sessions#create'
  get '/reimbursements/showuserreims', to: 'reimbursements#showUserReims'
  # Wouldn't work in resources for some reason during development. This just works so its left alone
  delete '/reimbursements/:id', to: 'reimbursements#delete'
  # Admin creation has a separate controller, so it can require a token of another admin
  post '/signup/admin', to: 'admins#create'

  # Just /reimbursements, use get, post, etc. appropriately to specify method along with /id when needed
  resources :reimbursements, only: %i[index create show update]

  # resources :users, except: %i[index show update delete] do
  #   resources :reimbursements, only: %i[ index show create update delete ]
  # end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
