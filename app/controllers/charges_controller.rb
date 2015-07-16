class ChargesController < ApplicationController

  def new
    # Amount in cents
    @amount = cart.total
  end

  def create
    @amount = cart.total

    customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :card => params[:stripeToken]
    )

    if Stripe::Charge.create(
        :customer => customer.id,
        :amount => @amount,
        :description => 'Rails Stripe customer',
        :currency => 'usd'
    )
      binding.pry
      ConfirmationMailer.confirmation_email(params[:stripeEmail]).deliver_now
      redirect_to user_orders_path
      cart.clear
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to user_orders_path
  end

end
