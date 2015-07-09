class OrdersController < ApplicationController
  load_and_authorize_resource

  def new
    @order = Order.new
  end

  def index
  end

  def create
    OrderParser.new.parse(cart, current_user, order_params)
    cart.clear
    flash[:notice] = "Your order has been successfully created!"
    redirect_to user_orders_path
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:errors] = e.message
    render :new
  end

  def show
    @order = Order.includes(:items).find(params[:id])
    @items = @order.items.group_by(&:id).values
  end

  private

  def order_params
    params.require(:order).permit(:street_number, :street, :city, :state, :zip, :exchange, :status)
  end
end
