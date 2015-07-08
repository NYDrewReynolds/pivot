class Admin::BaseController < ApplicationController
  before_filter :verify_admin

  private

    def verify_admin
      unless current_user && current_user.role == 'admin'
        flash[:error] = "You are not authorized to access this page."
        redirect_to root_path
      end
    end
end
