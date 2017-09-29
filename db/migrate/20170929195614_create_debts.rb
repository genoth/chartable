class CreateDebts < ActiveRecord::Migration[5.1]
  def change

    create_table :debts do |t|
      t.integer :employee_id
      t.integer :lender_id
      t.integer :debt_type_id
      t.float :max_amount
      t.float :min_amount
      t.integer :year_incurred
      t.string :rate
      t.string :term

      t.timestamps
    end

  end
end
