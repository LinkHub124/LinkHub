class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update]


  # get '/:user_name' => 'users#show', as: 'user'
  # ユーザー詳細画面を表示させる
  def show
    @user = User.find_by(name: params[:user_name])
    @theme_all = @user.themes.page(params[:page]).per(10)
  end


  # 内部ルート
  # ユーザー情報を更新する
  def update
    binding.pry
    if current_user.update(user_params)
      redirect_to user_path(user_name: current_user.name)
    else
      render :edit
    end
  end

  def create_rank(number)
    while UserRank.count < number
      UserRank.create
    end
    while UserRank.count > number
      user_rank = UserRank.all.sample(1)
      user_rank[0].user_id = nil
      user_rank[0].destroy
    end
  end

  def update_rank

    user_ranks = []
    post_favorite_count = {}
    UserRank.all.each do |user_rank|
      user_rank.user_id = nil
      user_ranks.append(user_rank.id)
    end
    # UserRank.destroy_all

    User.all.each do |user|
      post_favorite_count.store(user, Favorite.where(theme_id: Theme.where(user_id: user.id, post_status: 2).pluck(:id)).count)
      user.reload
    end

    user_post_favorite_ranks = post_favorite_count.sort_by { |_, v| v }.reverse.to_h

    user_post_favorite_ranks.each.with_index(1) do |(user, score), rank_index|
      user_rank = UserRank.find(user_ranks[rank_index-1])
      user_rank.update(user_id: user.id, rank: rank_index, score: score)
      puts user.name, score
    end
    puts "\n"

    # return @user_post_favorite_ranks
  end


  # patch '/users/withdrawal' => 'users#withdrawal', as: 'withdrawal'
  # ユーザーを退会処理
  def withdrawal
    if current_user.valid_password?(params[:user][:current_password])
      # is_deletedカラムをtrueに変更することにより削除フラグを立てる
      current_user.update(is_deleted: true)
      reset_session
      flash[:notice] = "退会処理を実行いたしました"
      redirect_to root_path
    else
      redirect_to unsubscribe_path
    end
  end


  private

    # 新規登録時、名前とプロフィール画像をコントローラに通す
    def user_params
      params.fetch(:user, {}).permit(:name, :profile_image)
    end

end
