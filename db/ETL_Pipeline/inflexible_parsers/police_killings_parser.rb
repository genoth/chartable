uid,full_name,age,gender,race_ethnicity,month,day,year,date,street_address,city,state,classification,law_enforcement_agency,if_armed
2016406,Terry Frost,20,Male,Black,May,25,2016,2016-05-25,2692 Madison Rd,Cincinnati,OH,Gunshot,Cincinnati Police Department,Firearm

require 'csv'
require_relative '../../../config/environment'

# counter = 0
CSV.foreach("db/ETL_Pipeline/raw_CSVs/updated_police_killings.csv", headers: true, header_converters: :symbol) do |row|
  # counter += 1
  # print '.' if counter % 100 == 0

  race = PoliceKillings::Race.find_or_create_by!(race: row[:race_ethnicity])
  sex = PoliceKillings::Sex.find_or_create_by!(sex: row[:gender])
  city = PoliceKillings::City.find_or_create_by!(city: row[:city])
  state = PoliceKillings::State.find_or_create_by!(state: row[:state])
  armed_type = PoliceKillings::ArmedType.find_or_create_by!(armed_type: row[:armed_type])
  classification = PoliceKillings::Classification.find_or_create_by!(classification: row[:classification])

  full_name = row[:name]
  date = row[:date]
  age = row[:age]
  street_address = row[:street_address]
  law_enforcement_agency = row[:law_enforcement_agency]


  death = PoliceKillings::Death.find_or_create_by!({
    name: full_name,
    date: date,
    age: age,
    street_address: street_address,
    law_enforcement_agency: law_enforcement_agency,
    race: race,
    sex: sex,
    city: city,
    state: state,
    armed_type: armed_type,
    classification: classification
    })

  puts row[:full_name]

end