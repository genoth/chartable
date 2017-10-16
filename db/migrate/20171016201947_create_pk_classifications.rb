class CreatePkClassifications < ActiveRecord::Migration[5.1]
  def change
    create_table :pk_classifications do |t|
      t.string :classification

      t.timestamps
    end
  end
end
