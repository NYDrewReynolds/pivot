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
      flash[:errors] = "Invalid Login"
      redirect_to root_path
      # render :new
    end
  end

  def destroy
    session.clear
    flash[:notice] = "Logout Successful"
    redirect_to root_path
  end

  private

    def correct_destination(user)
      user.is?('admin') ? admin_path : items_path
    end

end
