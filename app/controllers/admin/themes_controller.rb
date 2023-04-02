class Admin::ThemesController < ApplicationController
  def index
    @theme_all = Theme.all.reverse
    @theme_all = Kaminari.paginate_array(@theme_all).page(params[:page]).per(10)
  end
end