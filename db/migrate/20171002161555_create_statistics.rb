class CreateStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :statistics do |t|
      t.integer :race_id
      t.integer :sex_id
      t.integer :year_id
      t.float :age_adjusted_death_rate
      t.float :average_life_expectancy

      t.timestamps
    end
  end
end
