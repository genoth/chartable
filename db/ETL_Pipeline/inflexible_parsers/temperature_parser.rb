require 'csv'
require_relative '../../../config/environment'

CSV.foreach("db/ETL_Pipeline/raw_CSVs/temperature-change-seasons.csv", headers: true, header_converters: :symbol) do |row|

  puts row[:year]
  puts row[:winter_temperature_celsius]
  puts row[:spring_temperature_celsius]
  puts row[:summer_temperature_celsius]
  puts row[:fall_temperature_celsius]

  CanadianTempData::TempYear.find_or_create_by!({year: row[:year], winter_temperature_celsius: row[:winter_temperature_celsius], spring_temperature_celsius: row[:spring_temperature_celsius], summer_temperature_celsius: row[:summer_temperature_celsius], fall_temperature_celsius: row[:fall_temperature_celsius]})
end

puts CanadianTempData::TempYear.count
