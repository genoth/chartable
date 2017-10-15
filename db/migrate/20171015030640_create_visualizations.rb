class CreateVisualizations < ActiveRecord::Migration[5.1]
  def change
    create_table :visualizations do |t|
      t.string :link, unique: true

      t.timestamps
    end
  end
end
