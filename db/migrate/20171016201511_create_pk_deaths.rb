class CreatePkDeaths < ActiveRecord::Migration[5.1]
  def change
    create_table :pk_deaths do |t|
      t.string :name
      t.date :date
      t.integer :age
      t.string :street_address
      t.string :law_enforcement_agency
      t.integer :pk_race_id
      t.integer :pk_sex_id
      t.integer :pk_city_id
      t.integer :pk_state_id
      t.integer :pk_armed_type_id
      t.integer :pk_classification_id

      t.timestamps
    end
  end
end
