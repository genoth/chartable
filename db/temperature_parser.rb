require 'csv'
require_relative '../config/environment'

CSV.foreach("db/TemperatureChangeSeasons_EN.csv", headers: true, header_converters: :symbol) do |row|

  puts row[:year]
  puts row[:winter_temperature_celsius]

  CanadianTempData::Year.find_or_create_by!(row)
end

puts CanadianTempData::Year.count
