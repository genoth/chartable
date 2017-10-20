class RenameColInPkStates < ActiveRecord::Migration[5.1]
  def change
    rename_column :pk_states, :population, :perc_of_us_pop
  end
end
