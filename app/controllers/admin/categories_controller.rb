class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit, :update, :destroy]

	def index
		@items = current_restaurant.items
		@categories = current_restaurant.categories
	end

	def new
		@category = current_restaurant.categories.new
	end

	def edit
	end

	def create
		@category = current_restaurant.categories.new(category_params)
		if @category.save
			flash[:notice] = "Your category has been successfully created!"
			redirect_to restaurant_admin_dashboard_index_path(current_restaurant)
		else
			flash[:notice] = "Error saving category"
			redirect_to :back
		end
	end

	def update
		@category.update(category_params)
		redirect_to restaurant_admin_dashboard_index_path(current_restaurant)
	end

	def destroy
		@category.destroy
		redirect_to restaurant_admin_dashboard_index_path(current_restaurant)
	end

	private

    def category_params
      params.require(:category).permit(:title, :description)
    end

    def set_category
      @category = current_restaurant.categories.find(params[:id])
    end
end
