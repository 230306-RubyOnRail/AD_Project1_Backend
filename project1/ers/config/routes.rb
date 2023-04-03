Rails.application.routes.draw do
  get 'reimbursements', to: "reimbursements#index"
  post 'reimbursements', to: "reimbursements#create"
  get 'reimbursements', to: "reimbursements#show"
  put 'reimbursements', to: "reimbursements#put"
  delete 'reimbursements', to: "reimbursements#delete"
  post '/signup', to: 'users#create'
  post '/auth/login', to: 'sessions#create'

  # resources :users, except: %i[index show update delete]
  # # do
  # #   resources :reimbursements, only: %i[ index show create update delete ]
  # end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
