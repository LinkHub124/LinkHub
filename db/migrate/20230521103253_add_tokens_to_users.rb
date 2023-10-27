class AddTokensToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :tokens, :text
  end
end
