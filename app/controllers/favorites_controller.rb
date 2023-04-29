class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  include ActiveRecord::Sanitization::ClassMethods

  # GET '/:user_name/favorites' => 'favorites#index', as: 'user_favorites'
  # Description: いいね順にソートして表示.
  # Response:
  # @user => 詳細ページのユーザーを取得.
  # @theme_all => 表示させるいいね一覧を取得.
  def index
    @user = User.find_by(name: params[:user_name])
    @favorite_all = @user.favorites.select { |favorite| favorite.theme.post_status == 2 }

    # クエリパラメータにtheme_query(:tq)がある場合、検索処理をする.
    @favorite_all = search_favorites(@favorite_all, params[:tq]) if params[:tq]

    @favorite_all = @favorite_all.reverse # 降順に表示.
    @favorite_all = Kaminari.paginate_array(@favorite_all).page(params[:page]).per(MAX_THEMES_PER_PAGE)
  end

  # POST '/:user_name/themes/:theme_hashid/favorites' => 'favorites#create', as: 'theme_favorites'
  # Description: いいねを保存.
  # Response:
  # @theme => いいねを保存するテーマを取得.
  def create
    @theme = Theme.find(params[:theme_hashid])
    favorite = current_user.favorites.new(theme_id: @theme.id)
    favorite.save
  end

  # DELETE '/:user_name/themes/:theme_hashid/favorites' => 'favorites#destroy'
  # Description: いいねを削除.
  # Response:
  # @theme => いいねを削除するテーマを取得.
  def destroy
    @theme = Theme.find(params[:theme_hashid])
    favorite = current_user.favorites.find_by(theme_id: @theme.id)
    favorite.destroy
  end

  private

  # Description: 自分のいいねの検索.
  def search_favorites(favorite_all, search_text)
    favorite_searched = []
    favorite_all.each do |favorite|
      match_list = [favorite.theme.title, favorite.theme.user.name]
      favorite.theme.links.each do |link|
        match_list.push(link.subtitle)
        match_list.push(link.caption)
      end
      favorite.theme.tags.each do |tag|
        match_list.push(tag.name)
      end
      favorite_searched.push(favorite) if match_keyword?(search_text, match_list)
    end
    favorite_searched
  end
end
