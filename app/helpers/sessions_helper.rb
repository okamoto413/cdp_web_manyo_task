module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    user == current_user
  end

  def log_in(user)
    session[:user_id] = user.id
end

def logged_in?
  current_user.present?
end

def logged_out
  session.delete(:user_id)
  current_user = nill
end
end