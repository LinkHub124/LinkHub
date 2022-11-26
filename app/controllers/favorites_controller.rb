class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  # get '/:user_name/favorites' => 'favorites#index', as: 'user_favorites'
  # いいね順にソートして表示
  def index
    @user = User.find_by(name: params[:user_name])
    @favorite_all = @user.favorites.select { |favorite| favorite.theme.post_status == 2 }
    
    if params[:tq]
      query = params[:tq]
      @favorite_all = search_favorites(@favorite_all, query)
    end
    
    @favorite_all = @favorite_all.reverse
    @favorite_all = Kaminari.paginate_array(@favorite_all).page(params[:page]).per(10)
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
  
  private
    # 自分のいいねの検索
    def search_favorites(favorite_all, search_text)
      favorite_searched = []
      favorite_all.each { |favorite|
        flag = false
        flag = true if favorite.theme.title =~ %r{^.*#{search_text}.*}
        flag = true if favorite.theme.user.name =~ %r{^.*#{search_text}.*}
        favorite.theme.links.each { |link|
          flag = true if link.subtitle =~ %r{^.*#{search_text}.*} or link.caption =~ %r{^.*#{search_text}.*}
        }
        favorite.theme.tags.each { |tag|
          flag = true if tag.name =~ %r{^.*#{search_text}.*}
        }
        favorite_searched += Array(favorite) if flag == true
      }
      favorite_searched
    end

end
