class SearchesController < ApplicationController

  def search
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
      @theme_searched += user.themes
    }
    @theme_searched = @theme_searched.uniq
    @theme_searched = @theme_searched.select { |theme| theme.status == 2 }

  end
end