class Admin::OrdersController < Admin::BaseController

  before_action :set_order, except: [:index, :custom_show]

	def index
		@orders       = Order.all
		@ordered      = Order.where(:status => 'ordered')
		@paid         = Order.where(:status => 'paid')
		@completed    = Order.where(:status => 'completed')
		@cancelled    = Order.where(:status => 'cancelled')
	end

	def edit
    @order_items = @order.items_to_quantities
	end

	def update_quantity
    item_id = params[:item_id]
    @order.update_quantity(item_id, params[:quantity])

    respond_to do |format|
      format.js { @order }
    end
	end

	def remove_item
    @item_id = params[:item_id]
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
		redirect_to admin_orders_path
	end

	def status
		@order.status = params[:status]
		@order.save
		respond_to do |format|
			format.js { @order }
		end
	end

	def updated_at
		@order.updated_at = params[:updated_at]
		@order.save
		respond_to do |format|
			format.js { @order }
		end
	end

	def custom_show
		@orders = Order.where(:status => params[:status])
		@status = params[:status]
	end

  private

    def set_order
      @order = Order.find(params[:id])
    end
end
