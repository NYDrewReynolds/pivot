class Admin::ItemsController < Admin::BaseController
  before_action :set_item, except: [:new, :create]

  def new
    @item = current_restaurant.items.new
    @categories = current_restaurant.categories
  end

  def show
    @categories = @item.categories
  end

  def edit
    @categories = current_restaurant.categories
  end

  def create
    @item = current_restaurant.items.new(item_params)
    @categories = params[:categories] || []
    @categories.each do |category|
      category = current_restaurant.categories.find(category)
      @item.categories << category
    end
    if @item.save
      redirect_to restaurant_admin_dashboard_index_path(current_restaurant)
      flash[:notice] = "Your item has been successfully added to the menu!"
    else
      redirect_to :back
      flash[:notice] = "All fields are required to create a menu item, including category."
    end
  end

  def destroy
    @item.destroy
    redirect_to restaurant_admin_dashboard_index_path(current_restaurant)
  end

  def update
    @categories = params[:categories] || []
    @item.categories.clear
    @categories.each do |category|
      category = current_restaurant.categories.find(category)
      @item.categories << category
    end

    if @item.update(item_params)
      flash[:notice] = "Your item has been successfully updated!"
      redirect_to restaurant_admin_item_path(current_restaurant, @item)
    else
      redirect_to :back
      flash[:notice] = "Error saving item."
    end
  end

  private

    def item_params
      params.require(:item).permit(:title, :description, :price, :image, :category, :active)
    end

    def set_item
      @item = current_restaurant.items.friendly.find(params[:id])
    end

end
