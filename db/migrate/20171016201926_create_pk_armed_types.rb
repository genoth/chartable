class CreatePkArmedTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :pk_armed_types do |t|
      t.string :armed_type

      t.timestamps
    end
  end
end
