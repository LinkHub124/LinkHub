class RelationshipsController < ApplicationController
  # フォローするとき
  def create
    current_user.follow(params[:user_name])
    redirect_to request.referer
  end
  # フォロー外すとき
  def destroy
    current_user.unfollow(params[:user_name])
    redirect_to request.referer
  end
  # フォロー一覧
  def followings
    @user = User.find_by(name: params[:user_name])
    @users = @user.followings
  end
  # フォロワー一覧
  def followers
    @user = User.find_by(name: params[:user_name])
    @users = @user.followers
  end
end