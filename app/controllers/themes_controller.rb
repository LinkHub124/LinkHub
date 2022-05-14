class ThemesController < ApplicationController
  def new
    @theme_new = Theme.new
  end

  def create
    theme = Theme.new(theme_params)
    theme.user_id = current_user.id
    theme.save
    # binding.pry
    # redirect_to user_path(current_user.name)
    redirect_to theme_path(theme_hashid: theme.hashid)
  end

  def show
    @theme = Theme.find(params[:theme_hashid])
  end

  private
    def theme_params
      params.require(:theme).permit(:title, links_attributes: [:id, :user_id, :theme_id, :subtitle, :caption])
    end
end
