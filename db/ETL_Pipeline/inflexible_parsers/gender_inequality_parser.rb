require 'csv'
require_relative '../../../config/environment'

CSV.foreach("db/gender_inequality.csv", headers: true, header_converters: :symbol) do |row|


  gender_inequality_data = GenderInequality::GenderData.create!({
    country: row[:country],
    gender_inequality_index_2014: row[:gender_inequality_index_2014],
    gender_inequality_index_rank_2014: row[:gender_inequality_index_rank_2014],
    maternal_mortality_per_100k_2013: row[:maternal_mortality_per_100k_2013],
    adolescent_birth_rate_per_1k: row[:adolescent_birth_rate_per_1k],
    womens_share_of_seats_in_parliament_2014: row[:womens_share_of_seats_in_parliament_2014],
    share_of_women_w_some_secondary_education_25_and_up_2005_2014: row[:share_of_women_w_some_secondary_education_25_and_up_2005_2014],
    share_of_men_w_some_secondary_education: row[:share_of_men_w_some_secondary_education],
    women_labor_force_participation_rate_15_and_up_2013: row[:women_labor_force_participation_rate_15_and_up_2013],
    men_labor_force_participation_rate_2013: row[:men_labor_force_participation_rate_2013]
    })
end

puts GenderInequalityData::Data.pluck(:country)
