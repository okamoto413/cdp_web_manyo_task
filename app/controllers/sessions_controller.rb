class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user &.authenticate(params[:session][:password])
	  log_in (user)
	  redirect_to tasks_path
	  flash.now[:success] = "ログインしました"
	else
	  flash.now[:danger] = 'メールアドレスまたはパスワードに誤りがあります'
	  render :new
	end
  end

  def destroy
	session.delete(:user_id)
	flash[:notice] = "ログアウトしました"
    redirect_to new_session_path
  end    


  private

  def require_logout
    if current_user
      flash[:danger] = "ログアウトしてください"
      redirect_to tasks_path
    end
  end


  def login_required
      def current_user
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
      end

    if current_user
      #session_controllerの'new'（ログイン画面）にアクセスした場合
      if params[:controller] == "sessions" && params[:action] == "new" ||
      #users_controllerの'new'（アカウント登録画面）にアクセスした場合
         params[:controller] == "sessions" && params[:action] == "new"
         flash[:danger] = "ログアウトしてください"  
         redirect_to tasks_path
      end  
      else
        unless current_user
        flash[:danger] = "ログインしてください"
        redirect_to new_session_path
      end
    end
  end  
end

