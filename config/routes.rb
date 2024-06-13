Rails.application.routes.draw do
    #タスク一覧画面へのリンク
  root 'tasks#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:new, :create, :destroy]
   #タスク一覧
  resources :tasks, only: [:new, :show, :index, :edit, :create, :destroy, :update]

   #ユーザの登録フォームを作成
  resources :users, only: [:new, :create, :show, :edit, :update, :destro]
end
