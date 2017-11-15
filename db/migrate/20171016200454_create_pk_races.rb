class CreatePkRaces < ActiveRecord::Migration[5.1]
  def change

    create_table :pk_races do |t|
      t.string :race

      t.timestamps
    end
  end
end
