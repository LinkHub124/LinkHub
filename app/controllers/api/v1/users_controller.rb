class Api::V1::UsersController < ApplicationController
  def show
    user = User.find_by(name: params[:user_name])
    user.themes = user.themes.where(post_status: 2)
    render json: { status: 200, user: user.as_json(include: [:themes]) }
  end
end
