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
    agent = Mechanize.new
    link_new.one_links.each{ |one_link|
      begin
        page = agent.get(one_link.url)
      rescue
        one_link.url_title = "不正なURLです"
      else
        element = page.search('title')
        if element.inner_text == ""
          one_link.url_title = "タイトルなし"
        else
          one_link.url_title = element.inner_text
        end
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
      begin
        page = agent.get(one_link.url)
      rescue
        one_link.url_title = "不正なURLです"
      else
        element = page.search('title')
        if element.inner_text == ""
          one_link.url_title = "タイトルなし"
        else
          one_link.url_title = element.inner_text
        end
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
