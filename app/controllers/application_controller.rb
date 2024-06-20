class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required

  private
  def login_required
    unless current_user
      flash[:danger] = "ログインしてください"
      redirect_to new_session_path
    end
  end
end

