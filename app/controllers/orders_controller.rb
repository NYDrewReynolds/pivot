class OrdersController < ApplicationController
  load_and_authorize_resource

  def new
    @order = Order.new
  end

  def index
  end

  def create
    OrderParser.new.parse(cart, current_user, order_params)
    flash[:notice] = "Your order has been successfully created!"
    redirect_to new_charge_path
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:error] = e.message
    render :new
  end

  def show
    @order = Order.includes(:items).find(params[:id])
    @items = @order.items.group_by(&:id).values
  end

  private

  def order_params
    params.require(:order).permit(:street_number, :street, :city, :state, :zip)
  end
end
