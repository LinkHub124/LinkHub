class AddPositionToOneLink < ActiveRecord::Migration[5.2]
  def change
    add_column :one_links, :position, :integer
  end
end
