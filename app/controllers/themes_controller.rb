class ThemesController < ApplicationController
  before_action :correct_url, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :draft?, only: [:show]
  before_action :authenticate_user!, only: [:index_follow]

  # GET '/:user_name/themes/new' => 'themes#new', as: 'new_theme'
  # Description: Themeを新規投稿する.
  # Response:
  # @theme_new => 新規投稿のフォームを取得.
  def new
    @theme_new = Theme.new
  end

  # GET '/' => root to: 'themes#index'
  # Description: ホーム画面を表示、注目度の高い投稿、ユーザーランキングを表示させる、現在はタイムラインとほぼ同じ.
  # Response:
  # @theme_released_all => 全体公開になっている投稿を取得.
  def index
    @theme_released_all = Theme.where(post_status: 2)
    @theme_released_all = @theme_released_all.reverse
    @theme_released_all = Kaminari.paginate_array(@theme_released_all).page(params[:page]).per(10)
  end

  # GET '/followings' => 'themes#index_follow', as: 'index_follow'
  # Descirption: followしているユーザーの投稿一覧を返す.
  # Response:
  # @theme_released_following => followしているユーザーの投稿一覧を取得.
  def index_follow
    return unless user_signed_in?

    @theme_released_following = Theme.where(user_id: [*current_user.following_ids], post_status: 2)
    @theme_released_following = @theme_released_following.reverse
    @theme_released_following = Kaminari.paginate_array(@theme_released_following).page(params[:page]).per(10)
  end

  # POST '/:user_name' => 'themes#create', as: 'themes'
  # Description: 新しいThemeを保存.
  # Response:
  # @status => ステータスコード.
  def create
    theme_new = Theme.new(theme_params)
    theme_new.post_status = 0
    theme_new.user_id = current_user.id
    respond_to do |format|
      if theme_new.save
        format.js do
          redirect_to edit_theme_path(user_name: current_user.name, theme_hashid: theme_new.hashid), notice: 'リンクが保存されました'
        end
      else
        format.js { @status = 'fail' }
      end
    end
  end

  # GET '/:user_name/themes/:theme_hashid' => 'themes#show', as: 'theme'
  # Description: Themeに結びついたLinkを表示させる.
  # Response:
  # @theme => Themeを取得.
  # @theme_related_sort_by_fav => 関連投稿を取得.
  def show
    @theme = Theme.find(params[:theme_hashid])
    theme_released_all = Theme.where(post_status: 2)
    theme_related = theme_released_all.where.not(id: @theme.id).tagged_with(@theme.tags, any: true)
    theme_add_favcount = {}
    theme_related.all.each do |theme|
      theme_add_favcount.store(theme, theme.favorites.count)
      theme.reload
    end
    @theme_related_sort_by_fav = theme_add_favcount.sort_by { |_, v| v }.reverse.to_h
  end

  # GET '/:user_name/themes/:theme_hashid/edit' => 'themes#edit', as: 'edit_theme'
  # Description: Theme名、投稿状態、Themeに結びついたLinkを編集する.
  # Response:
  # @theme => Themeを取得.
  def edit
    @theme = Theme.find(params[:theme_hashid])
  end

  # PATCH '/:user_name/themes/:theme_hashid' => 'themes#update', as: 'update_theme'
  # Description: Themeに結びついたLinkを更新する.
  # Response:
  # @theme => Themeを取得.
  def update
    @theme = Theme.find(params[:theme_hashid])
    if @theme.update(theme_params)
      redirect_to theme_path(user_name: @theme.user.name, theme_hashid: @theme.hashid)
    else
      @theme = Theme.find(params[:theme_hashid])
      render :edit
    end
  end

  # DELETE '/:user_name/themes/:theme_hashid' => 'themes#destroy', as: 'destroy_theme'
  # Description: Themeを削除する.
  def destroy
    theme = Theme.find(params[:theme_hashid])
    theme.destroy
    redirect_to user_path(user_name: theme.user.name)
  end

  # Description: Themeを報告する.
  def report
    theme = Theme.find(params[:theme_hashid])
    flash[:notice] = '通報が完了しました。'
    ThemeMailer.with(theme: theme).send_report.deliver_now
    redirect_to theme_path(user_name: theme.user.name, theme_hashid: theme.hashid)
  end

  private

  # Descirption: 投稿・更新時、タイトルと投稿状態をコントローラに通す.
  def theme_params
    params.require(:theme).permit(:title, :post_status, :tag_list)
  end

  # Description: 直打ちで編集画面に遷移させない.
  def correct_user
    user = User.find_by(name: params[:user_name])
    # ログインユーザーと作成者が異なる時、Not Found
    render 'errors/404.html', status: :not_found unless user.id == current_user.id
  end

  # Description: 正しいURLかどうかを確かめる.
  def correct_url
    theme = Theme.find(params[:theme_hashid])
    user = User.find_by(name: params[:user_name])
    render 'errors/404.html', status: :not_found unless theme.user == user
  end

  # Description: 直打ちで下書き状態の画面に遷移させない.
  def draft?
    theme = Theme.find(params[:theme_hashid])
    user = User.find_by(name: params[:user_name])
    # (非公開かつ、ログインしていない) または、(非公開かつ、ログインユーザーと作成者が異なる) 時、Not Found
    render 'errors/404.html', status: :not_found if theme.post_status.zero? && (current_user.nil? || user.id != current_user.id)
  end
end
