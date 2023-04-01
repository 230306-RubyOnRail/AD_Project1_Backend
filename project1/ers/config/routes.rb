Rails.application.routes.draw do
  post 'reimbursement_list/create'
  get 'reimbursement_list/show'
  put 'reimbursement_list/update'
  delete 'reimbursement_list/delete'
  # get 'reimbursements/index'
  # post 'reimbursements/create'
  # get 'reimbursements/show'
  # put 'reimbursements/update'
  # delete 'reimbursements/delete'
  post '/signup', to: 'users#create'
  post '/auth/login', to: 'sessions#create'

  resources :users, except: %i[index show update delete] do
    resources :reimbursement_lists, path: '/lists', only: %i[ index show create update delete ] do
      resources :reimbursements, only: %i[ index show create update delete ]
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
