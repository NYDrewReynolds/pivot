class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :edit, :show_orders]

  def show
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(valid_params)

    if @restaurant.save
      @restaurant.update(owner_id: current_user.id)
      current_user.update(role: 'admin')
      redirect_to restaurant_path(@restaurant)
      flash[:notice] = "Your restaurant has been successfully created!"
    else
      redirect_to :back
      flash[:alert] = "All fields are required to create a restaurant."
    end
  end

  def edit
  end

  def update
    if @restaurant.update(valid_params)
      redirect_to restaurant_path(@restaurant), notice: "Restaurant details updated"
    else
      flash.now[:error] = @restaurant.errors.full_messages.join(", ")
      render :edit
    end
  end


  private

  def set_restaurant
    @restaurant = Restaurant.friendly.find(params[:id])
  end

  def valid_params
    params.require(:restaurant).permit(:name, :cuisine, :slug_name)
  end
end
