class FavoritesController < ApplicationController

  # get '/:user_name/favorites' => 'favorites#index', as: 'user_favorites'
  # いいね順にソートして表示
  def index
    @user = User.find_by(name: params[:user_name])
    @favorite_all = @user.favorites.reverse
  end


  # post '/:user_name/themes/:theme_hashid/favorites' => 'favorites#create', as: 'theme_favorites'
  # いいねを保存
  def create
    @theme = Theme.find(params[:theme_hashid])
    favorite = current_user.favorites.new(theme_id: @theme.id)
    favorite.save
  end


  # delete '/:user_name/themes/:theme_hashid/favorites' => 'favorites#destroy'
  # いいねを削除
  def destroy
    @theme = Theme.find(params[:theme_hashid])
    favorite = current_user.favorites.find_by(theme_id: @theme.id)
    favorite.destroy
  end

end
