class AddBlob < ActiveRecord::Migration[5.1]
  def change
    add_column :visualizations, :image_blob, :binary
  end
end
