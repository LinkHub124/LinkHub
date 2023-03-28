class SearchesController < ApplicationController
  # get '/search' => 'searches#search', as: 'search'
  # キーワードで検索、ユーザー名、タイトル、サブタイトル、キャプションに対応
  def search
    # 二文字未満なら例外処理
    # if params[:word].length < 2
    #   redirect_back(fallback_location: root_path)
    # end
    search_text = params[:word]
    @theme_searched = Theme.looks(search_text)

    link_searched = Link.looks(search_text)
    link_searched.each do |link|
      @theme_searched += Array(link.theme)
    end

    theme_all = Theme.all
    theme_all.each do |theme|
      flag = false
      theme.tags.each do |tag|
        flag = true if tag.name =~ /^.*#{search_text}.*/
      end
      @theme_searched += Array(theme) if flag == true
    end
    user_searched = User.looks(search_text)
    user_searched.each do |user|
      @theme_searched += user.themes.reverse
    end
    @theme_searched = @theme_searched.uniq
    @theme_searched = if user_signed_in?
                        @theme_searched.select { |theme| theme.post_status == 2 or theme.user == current_user }
                      else
                        @theme_searched.select { |theme| theme.post_status == 2 }
                      end

    @theme_searched_count = @theme_searched.length
    @theme_searched_page = Kaminari.paginate_array(@theme_searched).page(params[:page]).per(10)
  end
end
