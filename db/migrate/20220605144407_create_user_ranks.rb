class CreateUserRanks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_ranks do |t|
      t.integer :user_id
      t.integer :rank
      t.integer :score

      t.timestamps
    end
  end
end
