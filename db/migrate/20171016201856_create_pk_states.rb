class CreatePkStates < ActiveRecord::Migration[5.1]
  def change
    create_table :pk_states do |t|
      t.string :state

      t.timestamps
    end
  end
end
