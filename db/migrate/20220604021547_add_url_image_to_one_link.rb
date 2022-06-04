class AddUrlImageToOneLink < ActiveRecord::Migration[5.2]
  def change
    add_column :one_links, :url_image, :string
  end
end
