class CreateGenderInequality < ActiveRecord::Migration[5.1]
  def change
    create_table :gender_data do |t|

      t.string :country
      t.float :gender_inequality_index_2014
      t.integer :gender_inequality_index_rank_2014
      t.float :maternal_mortality_per_100k_2013
      t.float :adolescent_birth_rate_per_1k
      t.float :womens_share_of_seats_in_parliament_2014
      t.float :share_of_women_w_some_secondary_education_25_and_up_2005_2014
      t.float :share_of_men_w_some_secondary_education
      t.float :women_labor_force_participation_rate_15_and_up_2013
      t.float  :men_labor_force_participation_rate_2013

      t.timestamps
    end
  end
end
