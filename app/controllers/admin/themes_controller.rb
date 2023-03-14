class Admin::ThemesController < ApplicationController
  def index
    @theme_all = Theme.all.page(params[:page]).per(10)
  end
end