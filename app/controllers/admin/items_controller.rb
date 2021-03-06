class Admin::ItemsController < Admin::BaseController
  before_action :set_item, except: [:new, :create]

  def new
    @item = owned_restaurant.items.new
    @categories = owned_restaurant.categories
  end

  def show
    @categories = @item.categories
  end

  def edit
    @categories = owned_restaurant.categories
  end

  def create
    @item = owned_restaurant.items.new(item_params)
    @categories = params[:categories] || []
    @categories.each do |category|
      category = owned_restaurant.categories.find(category)
      @item.categories << category
    end
    if @item.save
      redirect_to restaurant_admin_dashboard_index_path(owned_restaurant)
      flash[:notice] = "Your item has been successfully added to the menu!"
    else
      redirect_to :back
      flash[:alert] = "All fields are required to create a menu item, including category."
    end
  end

  def destroy
    @item.destroy
    redirect_to restaurant_admin_dashboard_index_path(owned_restaurant)
  end

  def update
    @categories = params[:categories] || []
    @item.categories.clear
    @categories.each do |category|
      category = owned_restaurant.categories.find(category)
      @item.categories << category
    end

    if @item.update(item_params)
      flash[:notice] = "Your item has been successfully updated!"
      redirect_to restaurant_admin_item_path(owned_restaurant, @item)
    else
      redirect_to :back
      flash[:alert] = "Error saving item."
    end
  end

  private

    def item_params
      params.require(:item).permit(:title, :description, :price, :image, :category, :active)
    end

    def set_item
      @item = owned_restaurant.items.find(params[:id])
    end

end
