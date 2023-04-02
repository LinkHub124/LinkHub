class Admin::UsersController < ApplicationController
  def index
    @user_all = User.all.reverse
    @user_all = Kaminari.paginate_array(@user_all).page(params[:page]).per(10)
  end

  def show
    @user = User.find_by(name: params[:user_name])
    @theme_all = @user.themes.reverse
    @theme_all = Kaminari.paginate_array(@theme_all).page(params[:page]).per(10)
  end
end
