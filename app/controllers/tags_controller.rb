class TagsController < ApplicationController
  def index
    @tag_all = Theme.tag_counts
  end

  def show
    @theme_tagged_with = Theme.tagged_with(params[:tag_name])
  end
end
