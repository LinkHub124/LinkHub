class ThemesController < ApplicationController
  def new
    @theme_new = Theme.new
  end

  def index
  end

  def create
    theme = Theme.new(theme_params)
    theme.status = Theme.statuses[:draft]
    theme.user_id = current_user.id
    theme.save
    # binding.pry
    # redirect_to user_path(current_user.name)
    redirect_to edit_theme_path(theme_hashid: theme.hashid)
  end

  def show
    @theme = Theme.find(params[:theme_hashid])
  end

  def edit
    @theme = Theme.find(params[:theme_hashid])
    @link_all = @theme.links
  end

  private
    def theme_params
      params.require(:theme).permit(:title)
    end
end
