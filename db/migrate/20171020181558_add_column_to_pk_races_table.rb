class AddColumnToPkRacesTable < ActiveRecord::Migration[5.1]
  def change
    add_column :pk_races, :perc_of_us_pop, :float
  end
end
