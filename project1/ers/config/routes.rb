Rails.application.routes.draw do
  get 'sessions/create'
  get 'reimbursements/index'
  get 'reimbursements/create'
  get 'reimbursements/sow'
  get 'reimbursements/update'
  get 'reimbursements/delete'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
