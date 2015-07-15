class InviteMailer < ApplicationMailer


  def invite_email(email_address, owner, restaurant)
    @restaurant = restaurant
    @owner = owner
    mail(to: email_address, subject: "Join my staff!", from: "#{owner.first_name}@#{restaurant.name}.com")
  end
end
