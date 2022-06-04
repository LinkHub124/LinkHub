class LinksController < ApplicationController

  def new
    @link_new = Link.new
    @theme = Theme.find(params[:theme_hashid])
  end


  def create
    theme = Theme.find(params[:theme_hashid])
    link_new = Link.new(link_params)
    link_new.user_id = current_user.id
    link_new.theme_id = theme.id


    link_new.one_links.each{ |one_link|
      url = one_link.url

      if url == ""
        one_link.destroy
        next
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
          one_link.url_title = "タイトルがありません"
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
    link_new.save
    redirect_back(fallback_location: root_path)
  end

  def edit
    @link = Link.find(params[:link_hashid])
    @theme = Theme.find(params[:theme_hashid])
  end

  def update
    link = Link.find(params[:link_hashid]);
    link.one_links.each{ |one_link|
      url = one_link.url
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
          one_link.url_title = "タイトルがありません"
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
    link.update(link_params)
    redirect_to edit_theme_path(user_name: params[:user_name], theme_hashid: params[:theme_hashid])
  end

  def destroy
    link = Link.find(params[:link_hashid]);
    link.destroy;
    redirect_to edit_theme_path(user_name: params[:user_name], theme_hashid: params[:theme_hashid])
  end

  private

  def link_params
    params.require(:link).permit(:subtitle, :caption, :theme_id, :theme_hashid, one_links_attributes: [:id, :link_id, :url, :_destroy])
  end

end
