class ChangePkStatesPercColType < ActiveRecord::Migration[5.1]
  def change
    change_column :pk_states, :perc_of_us_pop, :float
  end
end
