class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.integer :user_id
      t.integer :theme_id
      t.string :subtitle
      t.text :caption
      t.timestamps
    end
  end
end
