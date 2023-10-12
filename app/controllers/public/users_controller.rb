class Public::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update, :unsubscribe, :withdrawal]

  # GET '/:user_name' => 'users#show', as: 'user'
  # Description: ユーザー詳細画面を表示.
  # Response:
  # @user => 詳細ページのユーザーを取得.
  # @theme_all => 表示させるテーマ一覧を取得.
  def show
    if params[:user_name] == 'users'
      redirect_to new_user_registration_path
    else
      @user = User.find_by(name: params[:user_name])
      @theme_all = @user.themes
      # ログインしてない、またはuserとcurrent_userが違かったらreleasedのみを表示.
      @theme_all = @theme_all.where(post_status: 2) unless user_signed_in? && @user == current_user

      # クエリパラメータにtheme_query(:tq)がある場合、検索処理をする.
      @theme_all = search_post(@theme_all, params[:tq]) if params[:tq]

      @theme_all = @theme_all.reverse # 降順に表示.
      @theme_all = Kaminari.paginate_array(@theme_all).page(params[:page]).per(MAX_THEMES_PER_PAGE)
    end
  end

  # GET '/users/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
  # Description: 退会画面を表示.
  def unsubscribe
  end

  # PATCH '/users/withdrawal' => 'users#withdrawal', as: 'withdrawal'
  # Description: ユーザーを退会処理.
  def withdrawal
    if current_user.valid_password?(params[:user][:current_password])
      current_user.update(is_deleted: true) # is_deletedカラムをtrueに変更することにより削除フラグを立てる.
      reset_session # セッション削除してログアウトさせる.
      flash[:notice] = '退会処理を実行いたしました'
      redirect_to root_path
    else
      redirect_to unsubscribe_path
    end
  end

  private

  # Description: ユーザー詳細画面でのテーマ検索.
  def search_post(theme_all, search_text)
    theme_searched = []
    theme_all.each do |theme|
      match_list = [theme.title, theme.user.name]
      theme.links.each do |link|
        match_list.push(link.subtitle)
        match_list.push(link.caption)
      end
      theme.tags.each do |tag|
        match_list.push(tag.name)
      end
      theme_searched.push(theme) if match_keyword?(search_text, match_list)
    end
    theme_searched
  end

  # Description: 新規登録時、名前とプロフィール画像をコントローラに通す.
  def user_params
    params.fetch(:user, {}).permit(:name, :profile_image)
  end
end
