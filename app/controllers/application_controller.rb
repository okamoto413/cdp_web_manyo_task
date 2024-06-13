class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required

  private

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

