class CreateThemeRanks < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_ranks do |t|
      t.integer :theme_id
      t.integer :rank
      t.integer :score

      t.timestamps
    end
  end
end
