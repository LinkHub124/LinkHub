class CreateOneLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :one_links do |t|
      t.integer :link_id
      t.string :url
      t.string :url_title
      t.string :url_description
      t.string :url_image

      t.timestamps
    end
  end
end
