class CreateOneLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :one_links do |t|
      t.integer :link_id
      t.text :url
      t.text :url_title
      t.text :url_description
      t.text :url_image

      t.timestamps
    end
  end
end
