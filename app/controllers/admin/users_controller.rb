class Admin::UsersController < ApplicationController
 #下記アクションの前に、操作するユーザーを設定する
 before_action :set_user, only: [:show, :edit, :update, :destroy]
 #管理者権限のチェックを行い、管理者以外のユーザーのアクセス制限をする
 before_action :admin_user,except: [:index, :show]

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
        redirect_to admin_user_path(@user)
        flash[:success] = 'ユーザを登録しました。'
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
      redirect_to admin_user_path(@user), 
      flash[:success] = 'ユーザを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_user_path(@user.id)
    flash[:success] = 'ユーザを削除しました'
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
    unless current_user?(@user)
      redirect_to(root_url)
    end
  end  

  def admin_user
    unless current_user.admin?
      redirect_to(root_url)
    end
  end
end
