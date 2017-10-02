class CreateYears < ActiveRecord::Migration[5.1]
  def change

    create_table :years do |t|
      t.integer :year
      t.float :winter_temperature_celsius
      t.float :spring_temperature_celsius
      t.float :summer_temperature_celsius
      t.float :fall_temperature_celsius

      t.timestamps
    end

  end
end
