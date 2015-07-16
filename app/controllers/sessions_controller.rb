class SessionsController < ApplicationController
  def new
    redirect_to root_path
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to correct_destination(user)
    else
      flash[:error] = "Invalid Login"
      redirect_to root_path
    end
  end

  def destroy
    session.clear
    flash[:notice] = "Logout Successful"
    redirect_to root_path
  end

  private

  def correct_destination(user)
    user.is?('admin') ? restaurant_admin_dashboard_index_path(owned_restaurant) : root_path
  end
end
