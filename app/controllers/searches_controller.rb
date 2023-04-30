class SearchesController < ApplicationController
  # GET '/search' => 'searches#search', as: 'search'
  # Description: キーワードで検索、ユーザー名、タイトル、サブタイトル、キャプションに対応
  # Response:
  # @theme_searched_count => 検索結果数.
  # @theme_searched_page => 検索結果.
  def search
    search_text = params[:word]
    theme_searched = []
    theme_all = Theme.all
    theme_all.each do |theme|
      match_list = [theme.title, theme.user.name]
      theme.links.each do |link|
        match_list.push(link.subtitle)
        match_list.push(link.caption)
      end
      theme.tags.each do |tag|
        match_list.push(tag.name)
      end
      theme_searched.push(theme) if match_keyword?(search_text, match_list)
    end
    
    theme_searched = if user_signed_in?
                        theme_searched.select { |theme| theme.post_status == 2 or theme.user == current_user }
                     else
                        theme_searched.select { |theme| theme.post_status == 2 }
                     end

    @theme_searched_count = theme_searched.length
    @theme_searched_page = Kaminari.paginate_array(theme_searched).page(params[:page]).per(MAX_THEMES_PER_PAGE)
  end
end
