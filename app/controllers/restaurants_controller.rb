class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :edit]

  def show
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(valid_params)
    @restaurant.user_id = current_user.id

    if @restaurant.save
      redirect_to restaurant_path(@restaurant)
      flash[:notice] = "Your restaurant has been successfully created!"
    else
      redirect_to :back
      flash[:notice] = "All fields are required to create a restaurant."
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
    @restaurant = Restaurant.find(params[:id])
  end

  def valid_params
    params.require(:restaurant).permit(:name, :cuisine)
  end
end
