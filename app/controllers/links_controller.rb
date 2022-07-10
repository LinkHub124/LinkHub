class LinksController < ApplicationController

  # get '/:user_name/themes/:theme_hashid/edit/new' => 'links#new', as: 'new_theme_link'
  # 新規Linkを作成
  def new
    @link_new = Link.new
    @theme = Theme.find(params[:theme_hashid])
  end


  # post '/:user_name/themes/:theme_hashid/edit' => 'links#create', as: 'theme_links'
  # スクレイピングをしてOGPを抜き出し、Linkを保存
  def create
    @user     = User.find_by(name: params[:user_name])
    @theme    = Theme.find(params[:theme_hashid])
    ret_link_params = link_params
    if ret_link_params[:one_links_attributes].blank? == false
      ret_link_params[:one_links_attributes].keys.each { |idx|
        url = ret_link_params[:one_links_attributes][idx][:url]
        if ret_link_params[:one_links_attributes][idx][:_destroy] != nil
          next
        end

        if url == ""
          ret_link_params[:one_links_attributes][idx][:_destroy] = 1
        end
      }
    end
    @link_new = Link.new(ret_link_params)

    @link_new.user_id  = current_user.id
    @link_new.theme_id = @theme.id


    @link_new.one_links.each{ |one_link|
      url = one_link.url
      url = encode_ja(url)
      if url.slice(0..6) == "http://" or url.slice(0..7) == "https://"

      else
        url = "https://" + url
      end


      charset = nil
      begin
        # ここの部分をキャッシュの有無で場合分けしたい
        html = OpenURI.open_uri(url) do |f|
          charset = f.charset # 文字種別を取得
          f.read # htmlを読み込んで変数htmlに渡す
        end
      rescue
        one_link.url_title = "不正なURLです"
      else
        # ノコギリを使ってhtmlを解析
        doc = Nokogiri::HTML.parse(html, charset)

        # title
        if doc.css('//meta[property="og:title"]/@content').empty?
          one_link.url_title = doc.title.to_s
        else
          one_link.url_title = doc.css('//meta[property="og:title"]/@content').to_s
        end

        if one_link.url_title == ""
          one_link.url_title = "タイトル未設定"
        end

        # description
        if doc.css('//meta[property="og:description"]/@content').empty?
          one_link.url_description = doc.css('//meta[name$="escription"]/@content').to_s
        else
          one_link.url_description = doc.css('//meta[property="og:description"]/@content').to_s
        end
        one_link.url_image = doc.css('//meta[property="og:image"]/@content').to_s
      end


    }

    respond_to do |format|
      if @link_new.save
        # format.html { redirect_to edit_theme_path(user_name: current_user.name, theme_hashid: @theme.hashid), notice: 'リンクが保存されました' }
        format.js { @status = "success" }
      else
        # format.html { render :new }
        format.js { @status = "fail" }
      end
    end
    # redirect_back(fallback_location: root_path)
  end


  # get '/:user_name/themes/:theme_hashid/edit/:link_hashid/edit' => 'links#edit', as: 'edit_theme_link'
  # Linkを編集する
  def edit
    @link  = Link.find(params[:link_hashid])
    @theme = Theme.find(params[:theme_hashid])
  end




  # patch '/:user_name/themes/:theme_hashid/edit/:link_hashid' => 'links#update', as: 'update_theme_link'
  # スクレイピングをしてOGPを抜き出し、Linkを更新
  def update
    @user  = User.find_by(name: params[:user_name])
    @theme = Theme.find(params[:theme_hashid])
    @link  = Link.find(params[:link_hashid])
    ret_link_params = link_params
    # binding.pry
    if ret_link_params[:one_links_attributes].blank? == false
      ret_link_params[:one_links_attributes].keys.each { |idx|
        url = ret_link_params[:one_links_attributes][idx][:url]
        if ret_link_params[:one_links_attributes][idx][:_destroy] != nil
          next
        end

        if url == ""
          ret_link_params[:one_links_attributes][idx][:_destroy] = 1
          next
        end
        url = encode_ja(url)
        
        if url.slice(0..6) == "http://" or url.slice(0..7) == "https://"

        else
          url = "https://" + url
        end
        
        charset = nil
        begin
          # ここの部分をキャッシュの有無で場合分けしたい
          html = OpenURI.open_uri(url) do |f|
            charset = f.charset # 文字種別を取得
            f.read # htmlを読み込んで変数htmlに渡す
          end
        rescue
          ret_link_params[:one_links_attributes][idx][:url_title] = "不正なURLです"
        else
          # ノコギリを使ってhtmlを解析
          doc = Nokogiri::HTML.parse(html, charset)

          # title
          if doc.css('//meta[property="og:title"]/@content').empty?
            ret_link_params[:one_links_attributes][idx][:url_title] = doc.title.to_s
          else
            ret_link_params[:one_links_attributes][idx][:url_title] = doc.css('//meta[property="og:title"]/@content').to_s
          end

          if ret_link_params[:one_links_attributes][idx][:url_title] == ""
            ret_link_params[:one_links_attributes][idx][:url_title] = "タイトル未設定"
          end

          # description
          if doc.css('//meta[property="og:description"]/@content').empty?
            ret_link_params[:one_links_attributes][idx][:url_description] = doc.css('//meta[name$="escription"]/@content').to_s
          else
            ret_link_params[:one_links_attributes][idx][:url_description] = doc.css('//meta[property="og:description"]/@content').to_s
          end

          ret_link_params[:one_links_attributes][idx][:url_image] = doc.css('//meta[property="og:image"]/@content').to_s
        end
      }
    end

    respond_to do |format|
      if @link.update(ret_link_params)
        # format.html { redirect_to edit_theme_path(user_name: current_user.name, theme_hashid: @theme.hashid), notice: 'リンクが保存されました' }
        format.js { @status = "success" }
      else
        # format.html { render :new }
        format.js { @status = "fail" }
      end
    end
    # redirect_to edit_theme_path(user_name: params[:user_name], theme_hashid: params[:theme_hashid])
  end


  # delete '/:user_name/themes/:theme_hashid/edit/:link_hashid' => 'links#destroy', as: 'destroy_theme_link'
  # Linkを削除する
  def destroy
    @theme =Theme.find(params[:theme_hashid])
    @link = Link.find(params[:link_hashid])
    @link_id = @link.id
    respond_to do |format|
      if @link.destroy
        # format.html { redirect_to edit_theme_path(user_name: current_user.name, theme_hashid: @theme.hashid), notice: 'リンクが保存されました' }
        format.js { @status = "success" }
      else
        # format.html { render :new }
        format.js { @status = "fail" }
      end
    end
    # redirect_to edit_theme_path(user_name: params[:user_name], theme_hashid: params[:theme_hashid])
  end

  private

    # 投稿時、Linkとそれに結びついたデータをコントローラに通す
    def link_params
      params.require(:link).permit(:subtitle, :caption, :theme_id, :theme_hashid, one_links_attributes: [:id, :link_id, :url, :_destroy])
    end

    # 日本語のみエンコード
    # 参考：https://www.mk-mode.com/blog/2013/08/15/ruby-url-encode-only-japanese/
    def encode_ja(url)
      ret = ""
      url.split(//).each do |c|
        if  /[-_.!~*'()a-zA-Z0-9;\/\?:@&=+$,%#]/ =~ c
          ret.concat(c)
        else
          ret.concat(CGI.escape(c))
        end
      end
      return ret
    end

end
