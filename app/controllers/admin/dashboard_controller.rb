class Admin::DashboardController < Admin::BaseController

  def index
    @items = current_restaurant.items
  end

end
