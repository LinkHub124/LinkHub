class TagsController < ApplicationController
  MAX_THEMES_PER_PAGE = 10

  # GET '/tags' => 'tags#index', as: 'tags'
  # Description: タグ一覧を表示.
  # Response:
  # @tag_all => タグ一覧を取得.
  def index
    @tag_all = Theme.tag_counts
    @tag_all = @tag_all.sort_by(&:taggings_count).reverse
  end

  # GET '/tags/:tag_name' => 'tags#show', as: 'tag'
  # Description: そのタグがついているテーマ一覧を表示.
  # Response:
  # @tag_name => タグの名前を取得.
  # @theme_tagged_with => そのタグがついているテーマ一覧を取得.
  def show
    @tag_name = params[:tag_name]
    @theme_tagged_with = Theme.tagged_with(params[:tag_name])
    @theme_tagged_with = @theme_tagged_with.select { |theme| theme.post_status == 2 }
    @theme_tagged_with = @theme_tagged_with.reverse
    @theme_tagged_with = Kaminari.paginate_array(@theme_tagged_with).page(params[:page]).per(MAX_THEMES_PER_PAGE)
  end
end
