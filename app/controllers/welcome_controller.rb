class WelcomeController < ApplicationController

  def index
  	@top_three=Item.all.limit(3)
  end

  def about
  end
end
