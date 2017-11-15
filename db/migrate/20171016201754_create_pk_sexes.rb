class CreatePkSexes < ActiveRecord::Migration[5.1]
  def change
    create_table :pk_sexes do |t|
      t.string :sex

      t.timestamps
    end
  end
end
