class CreateUserRanks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_ranks do |t|
      t.string :name
      t.integer :rank
      t.integer :score

      t.timestamps
    end
  end
end
