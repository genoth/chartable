class AddPopColToPkStates < ActiveRecord::Migration[5.1]
  def change
    add_column :pk_states, :total_pop_2016, :integer
  end
end
