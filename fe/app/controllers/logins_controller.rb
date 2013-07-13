# -*- coding:utf-8 -*-
class LoginsController < ApplicationController
  def show
      render "new"
  end

  def create
    user = User.find_by_name params[:name]
    if user && user.authenticate(params[:pass])
      session[:user_id] = user.id
      session[:ver] = Settings.version
      redirect_to "/judge"
    else
      flash.now.alert = "naidesu"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:ver] = nil
    @current_user = nil
    redirect_to "/judge"
  end
end
