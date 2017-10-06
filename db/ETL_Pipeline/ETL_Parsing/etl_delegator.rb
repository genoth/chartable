require 'csv'
require 'child_data_parse_out'
require 'parent_data_parse_out'

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
  [ [filepath_0],[department, last_name, first_name], [filepath_1, filepath_2] ],
  [ [filepath_1],[department], [filepath_3, filepath_4] ], # 3=departments, 4=employees
  [ [filepath_2],[lender], [filepath_5, filepath_6] ], # 5=lenders
  [ [filepath_6],[debt_type], [filepath_7, filepath_8] ] # 7=debt_types, 8=debts
]
