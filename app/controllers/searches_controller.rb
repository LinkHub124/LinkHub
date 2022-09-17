class SearchesController < ApplicationController

  # get '/search' => 'searches#search', as: 'search'
  # キーワードで検索、ユーザー名、タイトル、サブタイトル、キャプションに対応
  def search
    # 二文字未満なら例外処理
    # if params[:word].length < 2
    #   redirect_back(fallback_location: root_path)
    # end
    search_text = params[:word]
    @theme_searched  = Theme.looks(search_text)
    
    link_searched = Link.looks(search_text)
    link_searched.each{ |link|
      @theme_searched += Array(link.theme)
    }
    
    theme_all = Theme.all
    theme_all.each { |theme|
      flag = false
      theme.tags.each { |tag|
        if tag.name =~ %r{^.*#{search_text}.*} then
          flag = true
        end
      }
      if flag == true then
        @theme_searched += Array(theme)
      end
    }
    user_searched = User.looks(search_text)
    user_searched.each{ |user|
      @theme_searched += user.themes.reverse
    }
    @theme_searched = @theme_searched.uniq
    if user_signed_in?
      @theme_searched = @theme_searched.select { |theme| theme.post_status == 2 or theme.user == current_user }
    else
      @theme_searched = @theme_searched.select { |theme| theme.post_status == 2 }
    end
    
    @theme_searched_count = @theme_searched.length
    @theme_searched_page = Kaminari.paginate_array(@theme_searched).page(params[:page]).per(10)
  end
  
  def search_stock
    # 二文字未満なら例外処理
    @user = User.find_by(name: params[:user_name])
    
    # if params[:word].length < 2
    #   redirect_back(fallback_location: root_path)
    # end
    
    # @theme_searched  = @user.themes.grep(/.*params[:word].*/)
    search_text = params[:word]
    # @theme_searched = @user.themes.select { |theme| theme.title =~ %r{^.*#{search_text}.*} }
    # @theme_searched  = Theme.looks(params[:word])
    
    @theme_searched = []
    @theme_all = @user.themes
    @theme_all = @theme_all.reverse
    @theme_all.each{ |theme|
      flag = false
      if theme.title =~ %r{^.*#{search_text}.*} then
        flag = true
      end
      theme.links.each { |link|
        if link.subtitle =~ %r{^.*#{search_text}.*} or link.caption =~ %r{^.*#{search_text}.*} then
          flag = true
        end
      }
      theme.tags.each { |tag|
        if tag.name =~ %r{^.*#{search_text}.*} then
          flag = true
        end
      }
      if flag == true then
        @theme_searched += Array(theme)
      end
    }
    
    @theme_favorite_all = @user.favorites
    @theme_favorite_all = @theme_favorite_all.reverse
    @theme_favorite_all.each { |favorite|
      flag = false
      if favorite.theme.title =~ %r{^.*#{search_text}.*} then
        flag = true
      end
      favorite.theme.links.each { |link|
        if link.subtitle =~ %r{^.*#{search_text}.*} or link.caption =~ %r{^.*#{search_text}.*} then
          flag = true
        end
      }
      favorite.theme.tags.each { |tag|
        if tag.name =~ %r{^.*#{search_text}.*} then
          flag = true
        end
      }
      if flag == true then
        @theme_searched += Array(favorite.theme)
      end
    }
    
    # user_searched = User.looks(params[:word])
    # user_searched.each{ |user|
    #   @theme_searched += user.themes.reverse
    # }
    @theme_searched = @theme_searched.uniq
    if user_signed_in?
      @theme_searched = @theme_searched.select { |theme| theme.post_status == 2 or theme.user == current_user }
    else
      @theme_searched = @theme_searched.select { |theme| theme.post_status == 2 }
    end
    
    @theme_searched_count = @theme_searched.length
    @theme_searched_page = Kaminari.paginate_array(@theme_searched).page(params[:page]).per(10)
  end
end