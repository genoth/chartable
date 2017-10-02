require 'csv'
require_relative '../config/environment'

CSV.foreach("db/TemperatureChangeSeasons_EN.csv", headers: true, header_converters: :symbol) do |row|

  puts row[:year]
  puts row[:winter_temperature_celsius]




end
