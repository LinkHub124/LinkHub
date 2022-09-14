class AddRateToOneLink < ActiveRecord::Migration[5.2]
  def change
    add_column :one_links, :rate, :integer, null: false, default: 3
  end
end
