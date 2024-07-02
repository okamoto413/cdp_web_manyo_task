class Admin::UsersController < ApplicationController

 #下記アクションの前に、現在ログインしているユーザーを設定する
 #管理者権限のチェックを行い、管理者以外のユーザーのアクセス制限をする
  before_action :admin_user
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # N+1問題回避(includes)
   def index
    @users = User.includes(:tasks).all
  end
  
  def new
    @user = User.new
  end
    
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path(@user)
      flash[:success] =  I18n.t('flash_messages.user_created')
    else
      render :new
    end
  end
                
  def edit
  end
        
  def show
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path(@user)
      flash[:success] = I18n.t('flash_messages.user_updated')
    else
      # flash[:error] = @user.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t('flash_messages.user_destroyed')
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
    end
      redirect_to admin_users_path
  end  

      private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end   

  def set_user
     @user = User.find(params[:id])
   end
   
     # 正しいユーザーか確認
  def correct_user
    @user = User.find(params[:id])
    unless current_user == @user
    redirect_to tasks_path
    end
  end  

  def admin_user
    unless current_user.admin?
      flash[:alert] = I18n.t('flash_messages.only_admin')
      redirect_to tasks_path
    end
  end
end
