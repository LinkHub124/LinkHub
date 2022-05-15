class FavoritesController < ApplicationController

  def index
    @user = User.find_by(name: params[:user_name])
  end

  def create
    theme = Theme.find(params[:theme_hashid])
    favorite = current_user.favorites.new(theme_id: theme.id)
    favorite.save
    redirect_to theme_path(user_name: theme.user.name, theme_hashid: theme.hashid)
  end

  def destroy
    theme = Theme.find(params[:theme_hashid])
    favorite = current_user.favorites.find_by(theme_id: theme.id)
    favorite.destroy
    redirect_to theme_path(user_name: theme.user.name, theme_hashid: theme.hashid)
  end
end
