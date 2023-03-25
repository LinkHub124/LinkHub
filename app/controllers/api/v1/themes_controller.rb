class Api::V1::ThemesController < ApplicationController
  def index
    @themes = Theme.all
    render json: @themes.as_json(include: :links)
  end
end
