class CreatePkDeaths < ActiveRecord::Migration[5.1]
  def change
    create_table :pk_deaths do |t|
      t.string :name
      t.date :date
      t.integer :age
      t.string :street_address
      t.string :law_enforcement_agency
      t.integer :race_id
      t.integer :sex_id
      t.integer :city_id
      t.integer :state_id
      t.integer :armed_type_id
      t.integer :classification_id

      t.timestamps
    end
  end
end
