class CartController < ApplicationController
  before_action :set_item_id, except: [:edit, :destroy]

  def edit
    @cart_presenter = CartPresenter.new(current_user)
  end

  def add_item
    cart.add_item @item_id, params[:quantity]

    respond_to do |format|
      format.js { @item_id }
    end
  end

  def update_quantity
    cart.update_quantity(@item_id, params[:quantity])

    respond_to do |format|
      format.js {}
    end
  end

  def remove_item
    cart.delete(@item_id)

    respond_to do |format|
      format.js { @item_id }
    end
  end

  def destroy
    if cart.items
      cart.clear
      redirect_to :back
    else
      redirect_to :back
    end
  end


  private

    def set_item_id
      @item_id = params[:id]
    end
end
