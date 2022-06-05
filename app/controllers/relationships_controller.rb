class RelationshipsController < ApplicationController

  # post '/:user_name/relationships' => 'relationships#create', as: 'user_relationships'
  # 自分以外のユーザーをフォロー
  def create
    @user = User.find_by(name: params[:user_name])
    if current_user == @user
      return
    end
    current_user.follow(params[:user_name])
  end


  # delete '/:user_name/relationships' => 'relationships#destroy'
  # フォロー解除
  def destroy
    @user = User.find_by(name: params[:user_name])
    current_user.unfollow(params[:user_name])
  end


  # get '/:user_name/followings' => 'relationships#followings', as: 'user_followings'
  # フォロー一覧を表示させる
  def followings
    @user = User.find_by(name: params[:user_name])
  end


  # get '/:user_name/followers' => 'relationships#followers', as: 'user_followers'
  # フォロワー一覧を表示させる
  def followers
    @user = User.find_by(name: params[:user_name])
  end

end