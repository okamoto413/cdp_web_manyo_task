Rails.application.routes.draw do
    #タスク一覧画面へのリンク
  root 'tasks#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:new, :create, :destroy]
  # ログイン画面
  #  get 'new_session', to: 'sessions#new', # as: 'new_session' 

   #タスク関連
  resources :tasks, only: [:new, :show, :index, :edit, :create, :destroy, :update]

 
  #ユーザの登録フォームを作成   #一般ユーザー関連ルーティング
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy] do
    collection do
      get 'new', to: 'users#new'  # as: 'new_user'   # アカウント登録画面
    end
    member do
      get 'edit', to: 'users#edit' # as: 'edit_user'  # アカウント編集画面
      get '', to: 'users#show' # as:'user' # アカウント詳細画面
    end
  end

  # 管理者用のユーザ関連ルーティング
  namespace :admin do
    resources :users, only: [:new, :show, :index, :edit, :create, :destroy, :update] do
      collection do
        get '', to: 'users#index' # as: 'admin_users' # ユーザ一覧画面（管理者）
        get 'new', to: 'users#new' # as: 'new_admin_user'  # ユーザ登録画面（管理者）
      end
      member do  
        get 'edit', to: 'users#edit' # as: 'edit_admin_user'  # ユーザ編集画面（管理者）
        get '', to: 'users#show' # as: 'admin_user'  # ユーザ詳細画面（管理者）
      end
    end
  end
end
