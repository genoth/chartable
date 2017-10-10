require 'csv'
require_relative 'child_data_parse_out'
require_relative 'parent_data_parse_out'
require_relative 'etl'


pipeline_paths = [
  "db/test_destination/one.csv",
  "db/test_destination/two.csv",
  "db/test_destination/three.csv",
  "db/test_destination/four.csv",
  "db/test_destination/five.csv",
  "db/test_destination/six.csv",
  "db/test_destination/seven.csv",
  "db/test_destination/eight.csv",
  "db/test_destination/nine.csv",
  "db/test_destination/ten.csv",
  "db/test_destination/eleven.csv",
]

raw_data_file = "db/ETL_Pipeline/raw_CSVs/trump_admin_debts.csv"

normalization_information = [
  [ ['db/ETL_Pipeline/raw_CSVs/trump_admin_debts.csv'],[:department, :last_name, :first_name], ['db/test_destination/one.csv', 'db/test_destination/two.csv'] ],
  [ ['db/test_destination/one.csv'],[:department], ['db/test_destination/three.csv', 'db/test_destination/four.csv'] ], # 3=departments, 4=employees
  [ ['db/test_destination/two.csv'],[:lender], ['db/test_destination/five.csv', 'db/test_destination/six.csv'] ], # 5=lenders
  [ ['db/test_destination/six.csv'],[:debt_type], ['db/test_destination/seven.csv', 'db/test_destination/eight.csv'] ] # 7=debt_types, 8=debts
]

