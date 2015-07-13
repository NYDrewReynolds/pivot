class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit, :update, :destroy]

	def index
		@items = owned_restaurant.items
		@categories = owned_restaurant.categories
	end

	def new
		@category = owned_restaurant.categories.new
	end

	def edit
	end

	def create
		@category = owned_restaurant.categories.new(category_params)
		if @category.save
			flash[:notice] = "Your category has been successfully created!"
			redirect_to restaurant_admin_dashboard_index_path(owned_restaurant)
		else
			flash[:notice] = "Error saving category"
			redirect_to :back
		end
	end

	def update
		@category.update(category_params)
		redirect_to restaurant_admin_dashboard_index_path(owned_restaurant)
	end

	def destroy
		@category.destroy
		redirect_to restaurant_admin_dashboard_index_path(owned_restaurant)
	end

	private

    def category_params
      params.require(:category).permit(:title, :description)
    end

    def set_category
      @category = owned_restaurant.categories.find(params[:id])
    end
end
