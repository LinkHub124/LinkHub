class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  include ActiveRecord::Sanitization::ClassMethods

  layout 'app2', only: [:registrations_complete]

  def registrations_complete
    @password = $crypt.decrypt_and_verify(params[:encrypted_password])
  end

  def password
    redirect_to new_user_password_path
  end

  # get '/:user_name' => 'users#show', as: 'user'
  # ユーザー詳細画面を表示させる
  def show
    if params[:user_name] == 'users'
      redirect_to new_user_registration_path
    else
      @user = User.find_by(name: params[:user_name])
      @theme_all = @user.themes
      # ログインしてない、またはuserとcurrent_userが違かったらreleasedのみを表示
      @theme_all = @theme_all.where(post_status: 2) unless user_signed_in? && @user == current_user

      if params[:tq]
        query = params[:tq]
        @theme_all = search_post(@theme_all, query)
      end

      @theme_all = @theme_all.reverse
      @theme_all = Kaminari.paginate_array(@theme_all).page(params[:page]).per(10)
      # @theme_all = @theme_all.page(params[:page]).per(10)
    end
  end

  # def update_rank(number)
  #   post_favorite_count = {}
  #   user_ranks = []

  #   # Destroyを繰り返すとprimary_keyがオーバーフローする可能性がある

  #   if UserRank.count == number
  #     UserRank.all.each do |user_rank|
  #       user_rank.user_id = nil
  #       user_ranks.append(user_rank.id)
  #     end
  #     User.all.each do |user|
  #       post_favorite_count.store(user, Favorite.where(theme_id: Theme.where(user_id: user.id, post_status: 2).pluck(:id)).count)
  #       user.reload
  #     end
  #     user_post_favorite_ranks = post_favorite_count.sort_by { |_, v| v }.reverse.to_h

  #     user_post_favorite_ranks.each.with_index(1) do |(user, score), rank_index|
  #       next if rank_index > number

  #       UserRank.find(user_ranks[rank_index - 1]).update(user_id: user.id, rank: rank_index, score: score)
  #       # puts user.name
  #     end
  #   else
  #     UserRank.destroy_all
  #     User.all.each do |user|
  #       post_favorite_count.store(user, Favorite.where(theme_id: Theme.where(user_id: user.id, post_status: 2).pluck(:id)).count)
  #       user.reload
  #     end
  #     user_post_favorite_ranks = post_favorite_count.sort_by { |_, v| v }.reverse.to_h

  #     user_post_favorite_ranks.each.with_index(1) do |(user, score), rank_index|
  #       next if rank_index > number

  #       UserRank.create(user_id: user.id, rank: rank_index, score: score)
  #       # puts user.name
  #     end
  #   end

  #   # puts "\n"
  # end

  # patch '/users/withdrawal' => 'users#withdrawal', as: 'withdrawal'
  # ユーザーを退会処理
  def withdrawal
    if current_user.valid_password?(params[:user][:current_password])
      # is_deletedカラムをtrueに変更することにより削除フラグを立てる
      current_user.update(is_deleted: true)
      reset_session
      flash[:notice] = '退会処理を実行いたしました'
      redirect_to root_path
    else
      redirect_to unsubscribe_path
    end
  end

  private

  # 自分のテーマの検索
  def search_post(theme_all, search_text)
    theme_searched = []
    theme_all.each do |theme|
      flag = false
      flag = true if theme.title =~ /^.*#{sanitize_sql_like(search_text)}.*/
      flag = true if theme.user.name =~ /^.*#{sanitize_sql_like(search_text)}.*/
      theme.links.each do |link|
        flag = true if link.subtitle =~ /^.*#{sanitize_sql_like(search_text)}.*/ || link.caption =~ /^.*#{sanitize_sql_like(search_text)}.*/
      end
      theme.tags.each do |tag|
        flag = true if tag.name =~ /^.*#{sanitize_sql_like(search_text)}.*/
      end
      theme_searched += Array(theme) if flag == true
    end
    theme_searched
  end

  # 新規登録時、名前とプロフィール画像をコントローラに通す
  def user_params
    params.fetch(:user, {}).permit(:name, :profile_image)
  end
end
