class CreateLenders < ActiveRecord::Migration[5.1]
  def change

    create_table :lenders do |t|
      t.string :name
      t.timestamps
    end

  end
end
