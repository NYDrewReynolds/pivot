class UsersController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Your account was successfully created!"
      session[:user_id] = @user.id
      redirect_to items_path
    else
      flash[:error] = "Please be sure to include a name and a valid email."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = current_user

    @user.update_attributes(user_params)

    if @user.save
      flash[:notice] = "Your profile has been updated."
      session[:user_id] = @user.id
      redirect_to edit_user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
  end

  def show_orders
    @orders = Order.where(user_id: current_user.id)
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :nickname, :password, :password_confirmation)
    end
end
