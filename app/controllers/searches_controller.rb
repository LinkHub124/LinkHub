class SearchesController < ApplicationController

  # get '/search' => 'searches#search', as: 'search'
  # キーワードで検索、ユーザー名、タイトル、サブタイトル、キャプションに対応
  def search
    
    # 二文字以下なら例外処理
    if params[:word].length < 2
      redirect_back(fallback_location: root_path)
    end
    @theme_searched  = Theme.looks(params[:word])
    
    link_searched = Link.looks(params[:word])
    link_searched.each{ |link|
      @theme_searched += Array(link.theme)
    }
    user_searched = User.looks(params[:word])
    user_searched.each{ |user|
      @theme_searched += user.themes.reverse
    }
    @theme_searched = @theme_searched.uniq
    @theme_searched = @theme_searched.select { |theme| theme.post_status == 2 }
    
    @theme_searched_count = @theme_searched.length
    @theme_searched_page = Kaminari.paginate_array(@theme_searched).page(params[:page]).per(10)
  end
end