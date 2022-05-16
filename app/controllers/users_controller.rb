class UsersController < ApplicationController

  def show
    @user = User.find_by(name: params[:user_name])
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(user_name: current_user.name)
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:name)
    end

end
