class ThemesController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :is_draft, only: [:show]

  def new
    @theme_new = Theme.new
  end

  def index
    @theme_released_all = Theme.where(status: 2)
    @users = User.all
  end

  def create
    theme = Theme.new(theme_params)
    theme.status = 0
    theme.user_id = current_user.id
    theme.save
    redirect_to edit_theme_path(user_name: theme.user.name, theme_hashid: theme.hashid)
  end

  def show
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
    theme = Theme.find(params[:theme_hashid])
    theme.destroy
    redirect_to user_path(user_name: theme.user.name)
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

    def is_draft
      @theme = Theme.find(params[:theme_hashid])
      @user = User.find_by(name: params[:user_name])
      # @theme = Theme.find_by_hashid(params[:theme_hashid], user_id: @user.id)
      # binding.pry
      # 自分以外で下書き状態ならroot_pathに飛ばす
      if @user.id != current_user.id and @theme.status == 0
        redirect_to root_path
      end
    end

    # def calculate_user_score
    #   @user_all = User.all
    #   @user_all.each{ |user|
    #     user.score  = 0
    #     user.score += user
    #   }
    # end
end
