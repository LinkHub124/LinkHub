class ThemesController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :is_draft, only: [:show]

  # get '/:user_name/themes/new' => 'themes#new', as: 'new_theme'
  # Themeを新規投稿する
  def new
    @theme_new = Theme.new
  end


  # root to: 'themes#index'
  # ホーム画面を表示、注目度の高い投稿、ユーザーランキングを表示させる、現在はタイムラインとほぼ同じ
  def index
    @theme_released_following = Theme.where(user_id: [*current_user.following_ids], post_status: 2)
    @theme_released_following = @theme_released_following.reverse
    @theme_released_all = Theme.where(post_status: 2)
    @theme_released_all = @theme_released_all.reverse

    @users = User.all
    @user_ranks = UserRank.all
    @theme_ranks = ThemeRank.all
  end
  
  # 時間実行
  # ユーザーランキングを更新させる
  def update_rank(number)
    post_favorite_count = {}
    theme_ranks = []
    
    # Destroyを繰り返すとprimary_keyがオーバーフローする可能性がある
    
    if ThemeRank.count == number
      ThemeRank.all.each do |theme_rank|
        theme_rank.theme_id = nil
        theme_ranks.append(theme_rank.id)
      end
      Theme.all.each do |theme|
        if theme.post_status != 2
          next
        end
        post_favorite_count.store(theme, theme.favorites.count)
        theme.reload
      end
      theme_post_favorite_ranks = post_favorite_count.sort_by { |_, v| v }.reverse.to_h
      
      theme_post_favorite_ranks.each.with_index(1) do |(theme, score), rank_index|
        if rank_index > number
          next
        end
        ThemeRank.find(theme_ranks[rank_index-1]).update(theme_id: theme.id, rank: rank_index, score: score)
        # puts theme.title
      end
    else
      ThemeRank.destroy_all
      Theme.all.each do |theme|
        if theme.post_status != 2
          next
        end
        post_favorite_count.store(theme, theme.favorites.count)
        theme.reload
      end
      theme_post_favorite_ranks = post_favorite_count.sort_by { |_, v| v }.reverse.to_h
  
      theme_post_favorite_ranks.each.with_index(1) do |(theme, score), rank_index|
        if rank_index > number
          next
        end
        ThemeRank.create(theme_id: theme.id, rank: rank_index, score: score)
        # puts theme.title
      end
    end
    
    
    # puts "\n"
  end


  # post '/:user_name' => 'themes#create', as: 'themes'
  # 新しいThemeを保存
  def create
    theme_new = Theme.new(theme_params)
    theme_new.post_status = 0
    theme_new.user_id = current_user.id
    respond_to do |format|
      if theme_new.save
        # format.html { redirect_to edit_theme_path(user_name: current_user.name, theme_hashid: theme_new.hashid), notice: 'リンクが保存されました' }
        format.js { redirect_to edit_theme_path(user_name: current_user.name, theme_hashid: theme_new.hashid), notice: 'リンクが保存されました' }
      else
        # format.html { render :new }
        format.js { @status = "fail" }
      end
    end
  end


  # get '/:user_name/themes/:theme_hashid' => 'themes#show', as: 'theme'
  # Themeに結びついたLinkを表示させる
  def show
    unless @theme.user == @user
      render "errors/404.html", status: :not_found#, layout: "error"
    end
    @link_all = @theme.links
  end


  # get '/:user_name/themes/:theme_hashid/edit' => 'themes#edit', as: 'edit_theme'
  # Theme名、投稿状態、Themeに結びついたLinkを編集する
  def edit
    @theme = Theme.find(params[:theme_hashid])
    @link_all = @theme.links
  end


  # patch '/:user_name/themes/:theme_hashid' => 'themes#update', as: 'update_theme'
  # Themeに結びついたLinkを更新する
  def update
    theme = Theme.find(params[:theme_hashid])
    theme.update(theme_params)
    redirect_to theme_path(user_name: theme.user.name, theme_hashid: theme.hashid)
  end


  # delete '/:user_name/themes/:theme_hashid' => 'themes#destroy', as: 'destroy_theme'
  # Themeを削除する
  def destroy
    theme = Theme.find(params[:theme_hashid])
    theme.destroy
    redirect_to user_path(user_name: theme.user.name)
  end


  private

    # 投稿時、タイトルと投稿状態をコントローラに通す
    def theme_params
      params.require(:theme).permit(:title, :post_status, :tag_list)
    end


    # 直打ちで編集画面に遷移させない
    def correct_user
      user = User.find_by(name: params[:user_name])
      unless user.id == current_user.id
        render "errors/404.html", status: :not_found#, layout: "error"
      end
    end


    # 直打ちで下書き状態の画面に遷移させない
    def is_draft
      @theme = Theme.find(params[:theme_hashid])
      @user = User.find_by(name: params[:user_name])
      # @theme = Theme.find_by_hashid(params[:theme_hashid], user_id: @user.id)
      # binding.pry
      # 本当は404NotFoundにしたい
      if (current_user == nil or @user.id != current_user.id) and @theme.post_status == 0
        render "errors/404.html", status: :not_found#, layout: "error"
      end
    end

    # def calculate_user_score
    #   @user_all = User.all
    #   @user_all.each{ |user|
    #     user.score  = 0
    #     user.score += user
    #   }
    # end
end
