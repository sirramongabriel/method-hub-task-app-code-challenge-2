Rails.application.routes.draw do
  resources :users, only: [:get] do
    collection do 
      get ':id/tasks', to: 'tasks#by_user'
    end
  end
  resources :tasks do
    collection do
      post ':id/assign', to: 'tasks#assign'
      put ':id/progress', to: 'tasks#set_progress'
      get '/overdue', to: 'tasks#overdue'
      get '/status/:status', to: 'tasks#by_status'
      get '/completed', to: 'tasks#completed'
      get '/statistics', to: 'tasks#statistics'
    end
  end 
end
