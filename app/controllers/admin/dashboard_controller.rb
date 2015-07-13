class Admin::DashboardController < Admin::BaseController

  def index
    @items = owned_restaurant.items
  end

end
