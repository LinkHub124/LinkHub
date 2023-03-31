class RelationshipsController < ApplicationController
  # POST '/:user_name/relationships' => 'relationships#create', as: 'user_relationships'
  # Description: 自分以外のユーザーをフォロー.
  # Response
  # @user => フォローするユーザー.
  def create
    @user = User.find_by(name: params[:user_name])
    return if current_user == @user

    current_user.follow(@user.name)
  end

  # DELETE '/:user_name/relationships' => 'relationships#destroy'
  # Description: フォロー解除.
  # Response:
  # @user => フォロー解除するユーザー.
  def destroy
    @user = User.find_by(name: params[:user_name])
    current_user.unfollow(@user.name)
  end

  # GET '/:user_name/followings' => 'relationships#followings', as: 'user_followings'
  # Description: フォロー一覧を表示させる.
  # Response:
  # @user => 大元のユーザーを取得.
  # @user_followings => @userがフォローしているユーザー一覧を取得.
  def followings
    @user = User.find_by(name: params[:user_name])
    @user_followings = @user.followings.reverse
    @user_followings = Kaminari.paginate_array(@user_followings).page(params[:page]).per(MAX_THEMES_PER_PAGE)
  end

  # GET '/:user_name/followers' => 'relationships#followers', as: 'user_followers'
  # Description: フォロワー一覧を表示させる.
  # Response:
  # @user => 大元のユーザーを取得.
  # @user_followings => @userをフォローしているユーザー一覧を取得.
  def followers
    @user = User.find_by(name: params[:user_name])
    @user_followers = @user.followers.reverse
    @user_followers = Kaminari.paginate_array(@user.followers).page(params[:page]).per(MAX_THEMES_PER_PAGE)
  end
end
