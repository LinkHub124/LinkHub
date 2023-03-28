class RelationshipsController < ApplicationController
  # post '/:user_name/relationships' => 'relationships#create', as: 'user_relationships'
  # 自分以外のユーザーをフォロー
  def create
    @user = User.find_by(name: params[:user_name])
    return if current_user == @user

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
    @user_followings = @user.followings.reverse
    @user_followings = Kaminari.paginate_array(@user_followings).page(params[:page]).per(10)
  end

  # get '/:user_name/followers' => 'relationships#followers', as: 'user_followers'
  # フォロワー一覧を表示させる
  def followers
    @user = User.find_by(name: params[:user_name])
    @user_followers = @user.followers.reverse
    @user_followers = Kaminari.paginate_array(@user.followers).page(params[:page]).per(10)
  end
end
