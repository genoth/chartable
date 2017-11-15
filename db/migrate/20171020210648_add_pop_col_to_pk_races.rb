class AddPopColToPkRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :pk_races, :est_pop_2016, :float
  end
end

# 323127513

# [2, "White", .613, 198077165.47], [3, "Hispanic or Latino", 0.178, 57516697.314], [4, "Native American", 0.013, 4200657.669], [5, "Asian or Pacific Islander", 0.059, 19064523.267], [1, "Black", 0.133, 42975959.229]]