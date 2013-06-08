class RegistersController < ApplicationController
  def show
    @user = User.new
    render "new"
  end

  def create
    name  = params[:name]
    pass  = params[:pass]
    passc = params[:passc]
    @user = User.new
    @user.name = name
    @user.password = pass
    @user.password_confirmation = passc
    if @user.save
      redirect_to "/login"
    else
      render "new"
    end
  end
end
