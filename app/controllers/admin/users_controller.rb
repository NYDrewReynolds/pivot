class Admin::UsersController < Admin::BaseController
  before_action :set_user, except: [:index, :new, :create]

  def index
    @users = current_restaurant.users.all
  end

  def new
    @user = current_restaurant.users.new
  end

  def create
    @user = current_restaurant.users.new(user_params)
    if @user.save
      redirect_to restaurant_admin_dashboard_index_path
      flash[:notice] = "You successfully created #{@user.role} #{@user.full_name}!"
    else
      render :new
    end
  end

  def show
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account information has been successfully updated!"
      redirect_to restaurant_admin_dashboard_index_path
    else
      redirect_to :back
      flash[:notice] = "Error saving your new information."
    end
  end

  def destroy
    @user.destroy
    redirect_to restaurant_admin_dashboard_index_path
  end

  def edit
    render 'edit_user_role'
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :nickname, :email, :password, :role)
    end

    def set_user
      @user = current_restaurant.users.find(params[:id])
    end

end
