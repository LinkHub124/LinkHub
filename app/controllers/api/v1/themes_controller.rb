class Api::V1::ThemesController < ApplicationController
  def index
    theme_released_all = Theme.where(post_status: 2)
    theme_released_all = theme_released_all.reverse
    theme_released_all = Kaminari.paginate_array(theme_released_all).page(params[:page]).per(10)
    render json: { status: 200, themes: theme_released_all.as_json(include: [:links, :user]) }
  end

  def show
    theme = Theme.find_by(id: params[:id], post_status: 2)
    render json: { status: 200, theme: theme.as_json(include: [:links, :user]) }
  end
end
