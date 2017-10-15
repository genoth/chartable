class CreateVisualizations < ActiveRecord::Migration[5.1]
  def change
    create_table :visualizations do |t|
      t.text :image_data, limit: 128000

      t.timestamps
    end
  end
end
