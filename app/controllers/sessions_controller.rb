class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :require_logout, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
	  log_in(user)
	  flash[:success] = "ログインしました"
	  redirect_to tasks_path
	  else
	  flash[:danger] = 'メールアドレスまたはパスワードに誤りがあります'
	  render :new
	  end
  end

  def destroy
    log_out
    flash[:success] = "ログアウトしました"
    redirect_to new_session_path
  end    


  private

  def log_in(user)
    session[:user_id] = user.id
  end  

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end 

  def require_logout
    if current_user
    flash[:danger] = "ログアウトしてください"
    redirect_to tasks_path 
    end
  end

  def login_required
    redirect_to new_session_path unless current_user
  end
  
  #session_controllerの'new'（ログイン画面）にアクセスした場合
  #users_controllerの'new'（アカウント登録画面）にアクセスした場合
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    
    # if params[:controller] == "sessions" && params[:action] == "new" ||
    #     params[:controller] == "sessions" && params[:action] == "new"
    #     flash[:danger] = "ログアウトしてください"  
    #     redirect_to tasks_path
    # end  
    # else
    #   unless current_user
    #   flash[:danger] = "ログインしてください"
    #   redirect_to new_session_path
    # end
  end
end

