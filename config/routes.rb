Rails.application.routes.draw do
  root 'tasks#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tasks, only: [:new, :show, :index, :edit, :create, :destroy, :update]
end
