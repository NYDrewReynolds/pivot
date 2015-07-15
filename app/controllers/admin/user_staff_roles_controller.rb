class Admin::UserStaffRolesController < Admin::BaseController
  before_action :set_user, except: [:index, :new, :create]

  def index
    @user_staff_roles = owned_restaurant.user_staff_roles
  end

  def new
    @user_staff_role = owned_restaurant.user_staff_roles.new
  end

  def create
    binding.pry
    user = User.find_by(email: valid_params[:email])
    if user
      role = StaffRole.find_by(name: valid_params[:staff_role])
      user.user_staff_roles.new(restaurant_id: owned_restaurant.id, staff_role: role)
      if user.save
        redirect_to restaurant_admin_dashboard_index_path
        flash[:notice] = "You successfully added #{user.role} #{user.full_name}!"
      else
        render :new
      end
    else
      render :new
      #mailer goes here
    end
  end

  def show
  end

  def update
    role = StaffRole.find_by(name: valid_params[:staff_role])
    if @user_staff_role.update(staff_role: role)
      flash[:notice] = "Your account information has been successfully updated!"
      redirect_to restaurant_admin_user_staff_roles_path
    else
      redirect_to :back
      flash[:notice] = "Error saving your new information."
    end
  end

  def destroy
    @user_staff_role.destroy
    redirect_to restaurant_admin_dashboard_index_path
  end

  def edit
    render 'edit_user_staff_role'
  end

  private

    def valid_params
      params.require(:user_staff_role).permit(:staff_role, :email)
    end

    def set_user
      @user_staff_role = owned_restaurant.user_staff_roles.find(params[:id])
    end

end
