class WelcomeController < ApplicationController

  def index
  	@random_three = Restaurant.all.sample(3)
    @restaurants= Restaurant.all
  end

  def about
  end
end
