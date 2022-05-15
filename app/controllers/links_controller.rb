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
    link_new.save
    redirect_back(fallback_location: root_path)
  end

  private

  def link_params
    params.require(:link).permit(:subtitle, :caption, :theme_id, :theme_hashid, one_links_attributes: [:id, :link_id, :url])
  end

end
