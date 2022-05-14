class CreateOneLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :one_links do |t|
      t.integer :user_id
      t.integer :theme_id
      t.integer :link_id
      t.string :url

      t.timestamps
    end
  end
end
