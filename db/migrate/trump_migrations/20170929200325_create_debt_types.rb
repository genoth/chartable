class CreateDebtTypes < ActiveRecord::Migration[5.1]
  def change

    create_table :debt_types do |t|
      t.string :description
      t.timestamps
    end

  end
end
