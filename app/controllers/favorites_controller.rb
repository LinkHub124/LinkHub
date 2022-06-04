class FavoritesController < ApplicationController

  def index
    @user = User.find_by(name: params[:user_name])
    @favorite_all = @user.favorites.reverse
  end

  def create
    @theme = Theme.find(params[:theme_hashid])
    favorite = current_user.favorites.new(theme_id: @theme.id)
    favorite.save
  end

  def destroy
    @theme = Theme.find(params[:theme_hashid])
    favorite = current_user.favorites.find_by(theme_id: @theme.id)
    favorite.destroy
  end
end
