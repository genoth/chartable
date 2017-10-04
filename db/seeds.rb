require 'csv'
require_relative '../config/environment'
require_relative 'general_parser'


general_parser("db/gender_inequality.csv", GenderInequality::GenderData)

# namespace_table_name
# GenderInequality::GenderData

# CSV.foreach("db/gender_inequality.csv", headers: true, header_converters: :symbol) do |row|

#   gender_inequality_data = GenderInequality::GenderData.create!({
#     country: row[:country],
#     gender_inequality_index_2014: row[:gender_inequality_index_2014],
#     gender_inequality_index_rank_2014: row[:gender_inequality_index_rank_2014],
#     maternal_mortality_per_100k_2013: row[:maternal_mortality_per_100k_2013],
#     adolescent_birth_rate_per_1k: row[:adolescent_birth_rate_per_1k],
#     womens_share_of_seats_in_parliament_2014: row[:womens_share_of_seats_in_parliament_2014],
#     share_of_women_w_some_secondary_education_25_and_up_2005_2014: row[:share_of_women_w_some_secondary_education_25_and_up_2005_2014],
#     share_of_men_w_some_secondary_education: row[:share_of_men_w_some_secondary_education],
#     women_labor_force_participation_rate_15_and_up_2013: row[:women_labor_force_participation_rate_15_and_up_2013],
#     men_labor_force_participation_rate: row[:men_labor_force_participation_rate]
#     })
#   puts gender_inequality_data.gender_inequality_index_2014
#   puts gender_inequality_data.share_of_women_w_some_secondary_education_25_and_up_2005_2014
# end


# TrumpAdminDebts.parse("db/trump_admin_debts.csv")
CSV.foreach("db/trump_admin_debts.csv", headers: true, header_converters: :symbol) do |row|

  department = TrumpAdminDebts::Department.find_or_create_by!(name: row[:department])
  employee = TrumpAdminDebts::Employee.find_or_create_by!(last_name: row[:last_name], first_name: row[:first_name], department: department)
  lender = TrumpAdminDebts::Lender.find_or_create_by!(name: row[:lender_name])
  debt_type = TrumpAdminDebts::DebtType.find_or_create_by!(description: row[:debt_type])

  min_amount = (row[:min_amount]).to_i
  if row[:max_amount]
    max_amount = (row[:max_amount]).to_i
  end

  debt = TrumpAdminDebts::Debt.find_or_create_by!({
    employee: employee,
    lender: lender,
    debt_type: debt_type,
    min_amount: min_amount,
    max_amount: max_amount,
    year_incurred: row[:year_incurred],
    rate: row[:rate],
    term: row[:term]
    })
end



# puts TrumpAdminDebts::Department.count
# puts TrumpAdminDebts::Employee.pluck(:last_name)


