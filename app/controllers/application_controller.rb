class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required

  private
  def login_required
    unless current_user #ログインをせずにログイン画面とアカウント登録画面以外にアクセスした場合、ログインページに遷移させ「ログインしてください」というフラッシュメッセージを表示させること
      flash[:alert] = I18n.t('flash_messages.login_required')
      redirect_to new_session_path
    else #ログイン中にログイン画面、あるいはアカウント登録画面にアクセスした場合、タスク一覧画面に遷移させ「ログアウトしてください」というフラッシュメッセージを表示させる
      if accessing_login_or_signup?
      flash[:alert] = I18n.t('flash_messages.logout_required')
        redirect_to tasks_path
      end
    end
  end

  #ログイン画面やアカウント登録画面にアクセスしているか確認する
  def accessing_login_or_signup?
    request.fullpath == new_user_path || request.fullpath == new_session_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end

