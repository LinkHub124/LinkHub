class ThemesController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @theme_new = Theme.new
  end

  def index
    @theme_released_all = Theme.where(status: 2)
  end

  def create
    theme = Theme.new(theme_params)
    theme.status = 0
    theme.user_id = current_user.id
    theme.save
    redirect_to edit_theme_path(user_name: theme.user.name, theme_hashid: theme.hashid)
  end

  def show
    @theme = Theme.find(params[:theme_hashid])
    @user = User.find_by(name: params[:user_name])
    unless @theme.user == @user
      redirect_to root_path
    end
  end

  def edit
    @theme = Theme.find(params[:theme_hashid])
  end

  def update
    theme = Theme.find(params[:theme_hashid])
    theme.update(theme_params)
    redirect_to theme_path(user_name: theme.user.name, theme_hashid: theme.hashid)
  end

  def destroy
  end

  private

    def theme_params
      params.require(:theme).permit(:title, :status)
    end

    def correct_user
      user = User.find_by(name: params[:user_name])
      unless user.id == current_user.id
        redirect_to root_path
      end
    end
end
