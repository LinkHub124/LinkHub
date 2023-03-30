class LinksController < ApplicationController
  before_action :correct_url, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:new, :create, :edit, :update, :destroy]
  helper_method :get_tld

  # GET '/:user_name/themes/:theme_hashid/edit/new' => 'links#new', as: 'new_theme_link'
  # Description: 新規リンク集を作成.
  # Response:
  # @link_new => 新規リンク集フォーム.
  # @theme => テーマを取得.
  # @user => 投稿ユーザーを取得.
  def new
    @link_new = Link.new
    @theme = Theme.find(params[:theme_hashid])
    @user = User.find_by(name: params[:user_name])
  end

  # POST '/:user_name/themes/:theme_hashid/edit' => 'links#create', as: 'theme_links'
  # Description: スクレイピングをしてOGPを抜き出し、Linkを保存.
  # Response:
  # @link_new => 新規に作成するリンク集.
  # @status => ステータスコード.
  def create
    theme = Theme.find(params[:theme_hashid])
    new_link_params = link_params
    new_link_params = format_link_params(new_link_params) unless new_link_params[:one_links_attributes].blank?

    @link_new = Link.new(new_link_params)
    @link_new.user_id  = current_user.id
    @link_new.theme_id = theme.id

    respond_to do |format|
      if @link_new.save
        format.js { @status = 'success' }
      else
        format.js { @status = 'fail' }
      end
    end
  end

  # GET '/:user_name/themes/:theme_hashid/edit/:link_hashid/edit' => 'links#edit', as: 'edit_theme_link'
  # Description: リンク集を編集する.
  # Response:
  # @link => 投稿したリンク集.
  # @theme => テーマを取得.
  # @user => 投稿ユーザーを取得.
  def edit
    @link = Link.find(params[:link_hashid])
    @theme = Theme.find(params[:theme_hashid])
    @user = User.find_by(name: params[:user_name])
  end

  # PATCH '/:user_name/themes/:theme_hashid/edit/:link_hashid' => 'links#update', as: 'update_theme_link'
  # Description: スクレイピングをしてOGPを抜き出し、リンク集を更新.
  # Response:
  # @link => 更新したリンク集.
  # @status => ステータスコード.
  def update
    new_link_params = link_params
    new_link_params = format_link_params(new_link_params) unless new_link_params[:one_links_attributes].blank?

    @link = Link.find(params[:link_hashid])

    respond_to do |format|
      if @link.update(new_link_params)
        format.js { @status = 'success' }
      else
        format.js { @status = 'fail' }
      end
    end
  end

  # DELETE '/:user_name/themes/:theme_hashid/edit/:link_hashid' => 'links#destroy', as: 'destroy_theme_link'
  # Description: リンク集を削除する.
  # Response:
  # @link_id => 消去するリンク集のID
  # @theme => テーマを取得.
  # @status => ステータスコード.
  def destroy
    link = Link.find(params[:link_hashid])
    @link_id = link.id
    @theme = Theme.find(params[:theme_hashid])

    respond_to do |format|
      if link.destroy
        format.js { @status = 'success' }
      else
        format.js { @status = 'fail' }
      end
    end
  end

  # PATCH '/:user_name/themes/:theme_hashid/:link_hashid/sort' => 'links#sort'
  # Description: リンクを並べ替える.
  def sort
    link = Link.find(params[:link_hashid])
    one_link = link.one_links[params[:from].to_i]
    one_link.insert_at(params[:to].to_i + 1)
    head :ok
  end

  def get_tld(url)
    sz = url.length
    if url.slice(0..6) == 'http://'
      url = url.slice(7..sz)
    elsif url.slice(0..7) == 'https://'
      url = url.slice(8..sz)
    end
    sz = url.length
    idx = -1
    (0..sz).each do |num|
      if url[num] == '/'
        idx = num
        break
      end
    end
    url = url.slice(0..idx - 1) unless idx == -1
    url
  end

  private

  # Description: 投稿・更新時、Linkとそれに結びついたデータをコントローラに通す.
  def link_params
    params.require(:link).permit(:subtitle, :caption, :theme_id, :theme_hashid,
                                 one_links_attributes: [:id, :link_id, :url, :rate, :_destroy])
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

  # Description: URLの日本語をエンコード.
  # 参考: https://www.mk-mode.com/blog/2013/08/15/ruby-url-encode-only-japanese/
  def encode_ja(url)
    ret = ''
    url.split(//).each do |c|
      if %r{[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]} =~ c
        ret.concat(c)
      else
        ret.concat(CGI.escape(c))
      end
    end
    ret
  end

  # Description: Linkに紐づいているOneLinkごとにスクレイピングして情報を追加する
  def format_link_params(link_params)
    link_params[:one_links_attributes].values.each do |one_link|
      # URLが空、もしくは削除済みの場合next
      one_link[:_destroy] = 1 if one_link[:url] == ''
      next unless one_link[:_destroy].nil?

      url = encode_ja(one_link[:url])

      # one_linkの各初期値を設定.
      one_link[:url] = "https://#{url}" unless url.slice(0..6) == 'http://' || url.slice(0..7) == 'https://'
      one_link[:url_title] = 'URLが間違っています'
      one_link[:url_description] = nil
      one_link[:url_image] = nil

      # スクレイピング.
      charset = nil
      begin
        html = OpenURI.open_uri(one_link[:url]) do |f|
          charset = f.charset # 文字種別を取得.
          f.read # htmlを読み込んで変数htmlに渡す.
        end
      rescue StandardError
        next
      else
        doc = Nokogiri::HTML.parse(html, charset) # Nokogiriを使ってhtmlを解析.

        # url_title
        one_link[:url_title] = if doc.css('//meta[property="og:title"]/@content').empty?
                                 doc.title.to_s
                               else
                                 doc.css('//meta[property="og:title"]/@content').to_s
                               end
        one_link[:url_title] = 'タイトル未設定' if one_link[:url_title] == ''

        # url_description
        one_link[:url_description] = if doc.css('//meta[property="og:description"]/@content').empty?
                                       doc.css('//meta[name$="escription"]/@content').to_s
                                     else
                                       doc.css('//meta[property="og:description"]/@content').to_s
                                     end

        # url_image
        one_link[:url_image] = doc.css('//meta[property="og:image"]/@content').to_s
      end
    end
    link_params
  end
end
