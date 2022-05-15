class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.integer :user_id
      t.string :title
      t.integer :status # 0:draft, 1:limited, 2:public

      t.timestamps
    end
  end
end
