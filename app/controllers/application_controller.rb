class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do | exception |
    redirect_to login_url, alert: exception.message
  end

  after_filter :save_cart_in_session

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def set_time_zone
      Time.zone = current_user.time_zone
    end

    def cart
      @cart ||= Cart.new(session[:cart])
    end
    helper_method :cart

    def save_cart_in_session
      session[:cart] = cart.to_a
    end

  def owned_restaurant
    @owned_restaurant ||= Restaurant.find_by(owner_id: current_user.id)
  end

  helper_method :owned_restaurant

end
