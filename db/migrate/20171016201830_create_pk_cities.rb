class CreatePkCities < ActiveRecord::Migration[5.1]
  def change
    create_table :pk_cities do |t|
      t.string :city

      t.timestamps
    end
  end
end
