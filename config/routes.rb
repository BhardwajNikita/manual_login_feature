Rails.application.routes.draw do
  root to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'register', to: 'registrations#new'
  post 'register', to: 'registrations#create'
end
