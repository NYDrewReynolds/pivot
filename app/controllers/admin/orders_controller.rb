class Admin::OrdersController < Admin::BaseController
  before_action :set_order, except: [:index, :custom_show]
  before_action :set_item_id, only: [:update_quantity, :remove_item]

	def index
		@orders       = current_restaurant.orders.all
		@ordered      = current_restaurant.orders.where(:status => 'ordered')
		@paid         = current_restaurant.orders.where(:status => 'paid')
		@completed    = current_restaurant.orders.where(:status => 'completed')
		@cancelled    = current_restaurant.orders.where(:status => 'cancelled')
	end

	def edit
    @order_items = @order.items_to_quantities
	end

	def update_quantity
    @order.update_quantity(@item_id, params[:quantity])

    respond_to do |format|
      format.js { @order }
    end
	end

	def remove_item
    @order.items.destroy(@item_id)
    if @order.items.empty?
    	@order.status = "cancelled"
    end
    @order.save
    respond_to do |format|
      format.js { @item_id; @order }
    end
  end

	def destroy
		@order.destroy
		flash[:notice]="Your shit is destroyed"
		redirect_to restaurant_admin_orders_path(current_restaurant)
	end

	def status
		@order.status = params[:status]
		@order.save
		respond_to do |format|
			format.js { @order }
		end
	end

	def custom_show
		@orders = current_restaurant.orders.where(:status => params[:status])
		@status = params[:status]
	end

  private

    def set_order
      @order = current_restaurant.orders.find(params[:id])
    end

    def set_item_id
      @item_id = params[:item_id]
    end
end
