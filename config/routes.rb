Rails.application.routes.draw do

    #タスク一覧画面へのリンク
  root 'tasks#index'

  # ログイン画面
  # For details on the DSL available within this fFile, see https://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:new, :create, :destroy]

   #タスク関連
  resources :tasks, only: [:new, :show, :index, :edit, :create, :destroy, :update]
 
  #ユーザの登録フォームを作成   #一般ユーザー関連ルーティング
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]


  # 管理者用のユーザ関連ルーティング
  namespace :admin do
    resources :users, only: [:new, :show, :index, :edit, :create, :destroy, :update]
  end

  # ラベル一覧画面/登録画面/編集画面
  # ラベル一覧画面にラベルに紐づいているタスクの数を表示させること
  #  resources :users, only: [:show] do
  resources :labels, only: [:index, :new, :create, :edit, :destroy, :update]
  # end

  # エラーページ
  match "/404", to: "errors#not_found", via: :all
  match "/405", to: "errors#internal_server_error", via: :all

  get 'test_500', to: 'application#test_500'

end
