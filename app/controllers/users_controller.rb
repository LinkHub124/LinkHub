class UsersController < ApplicationController
  def show
    @user = User.find_by(name: params[:user_name])
    @theme_all = @user.themes
  end
end
