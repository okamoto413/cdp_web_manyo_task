class UsersController < ApplicationController
  before_action :correct_user, only: [:show, :update, :destroy ]
  skip_before_action :login_required, only: [:new, :create]
  before_action :logout_required, only:[:new, :create]
  # ユーザーによって実行可能
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

   #アカウントを登録する
  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to tasks_path
      session[:user_id] = @user.id
      flash[:success]= I18n.t('flash_messages.account_created')
    else
      render :new
    end
  end

  #アカウントを編集する
  def edit
  end

  #アカウント詳細画面
  def show
  end  

  #アカウントを更新する
  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id)
      flash[:success]=  I18n.t('flash_messages.account_updated')
    else
      # flash[:error] = @user.errors.full_messages.join(", ")
      render :edit
    end
  end

  #アカウント削除する
  def destroy
    @user.destroy
    redirect_to new_session_path(@user.id)
  end  

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end   

  def set_user
     @user = User.find(params[:id])
  end  

   #正しいユーザーか確認
  def correct_user
     @user = User.find(params[:id])
     unless current_user?(@user)
       redirect_to tasks_path
     end
   end  

  def admin_user
    redirect_to @user
    unless current_user.admin?
    end
  end   

  def logout_required #ログインしていたら、ログアウトの表示させるかつ、タスク一覧画面へ遷移する。
    if current_user
    redirect_to tasks_path
    flash[:notice]=  I18n.t('flash_messages.logout_required')
    end
  end
end
