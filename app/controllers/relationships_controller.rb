class RelationshipsController < ApplicationController

  def create
    @user = User.find_by(name: params[:user_name])
    current_user.follow(params[:user_name])
  end

  def destroy
    @user = User.find_by(name: params[:user_name])
    current_user.unfollow(params[:user_name])
  end
  # フォロー一覧
  def followings
    @user = User.find_by(name: params[:user_name])
  end
  # フォロワー一覧
  def followers
    @user = User.find_by(name: params[:user_name])
  end
end