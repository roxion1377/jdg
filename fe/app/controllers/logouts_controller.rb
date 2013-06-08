class LogoutsController < ApplicationController
  def show
    session[:user_id] = nil
    redirect_to "/judge"
  end
end
