class AddColumnToPkStatesTable < ActiveRecord::Migration[5.1]
  def change
    add_column :pk_states, :population, :integer
  end
end
