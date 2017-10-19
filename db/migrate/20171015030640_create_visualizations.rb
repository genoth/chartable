class CreateVisualizations < ActiveRecord::Migration[5.1]
  def change
    create_table :visualizations do |t|
      t.string :link, unique: true
      t.string :public_id
      t.string :dataset_id

      t.timestamps
    end
  end
end
