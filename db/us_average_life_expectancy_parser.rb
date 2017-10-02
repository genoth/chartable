require 'csv'
require_relative '../config/environment'

counter = 0
CSV.foreach("db/birth-death-rate.csv", headers: true, header_converters: :symbol) do |row|
  counter += 1
  print '.' if counter % 100 == 0

  race = USLifeExpectancy::Race.find_or_create_by!(race: row[:race])
  sex = USLifeExpectancy::Sex.find_or_create_by!(sex: row[:sex])
  year = USLifeExpectancy::Year.find_or_create_by!(year: row[:year])

  age_adjusted_death_rate = row[:age_adjusted_death_rate]
  average_life_expectancy = row[:average_life_expectancy_in_years]

  statistic = USLifeExpectancy::Statistic.find_or_create_by!({
    year: year,
    race: race,
    sex: sex,
    age_adjusted_death_rate: age_adjusted_death_rate,
    average_life_expectancy: average_life_expectancy
    })

  # puts row[:average_life_expectancy]
  # puts row[:race]
  # puts row[:age_adjusted_death_rate]

end
