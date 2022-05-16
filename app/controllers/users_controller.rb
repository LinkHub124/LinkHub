class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def show
    @user = User.find_by(name: params[:user_name])
  end


  def update
    if current_user.update(user_params)
      redirect_to user_path(user_name: current_user.name)
    else
      render :edit
    end
  end

  def withdrawal
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    current_user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

    def user_params
      params.fetch(:user, {}).permit(:name)
    end

end
