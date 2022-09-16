class TagsController < ApplicationController
  def index
    @tag_all = Theme.tag_counts
    @tag_all = @tag_all.sort_by{|tag| tag.taggings_count}.reverse
  end

  def show
    @tag_name = params[:tag_name]
    @theme_tagged_with = Theme.tagged_with(params[:tag_name])
    @theme_tagged_with = @theme_tagged_with.select { |theme| theme.post_status == 2 }
    @theme_tagged_with = @theme_tagged_with.reverse
    @theme_tagged_with = Kaminari.paginate_array(@theme_tagged_with).page(params[:page]).per(10)
  end
end
