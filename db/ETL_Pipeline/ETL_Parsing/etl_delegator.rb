require 'csv'
require 'fileutils'
require_relative 'child_data_parse_out'
require_relative 'parent_data_parse_out'
require_relative 'etl'



pipeline_paths = [
  "db/ETL_Pipeline/ETL_staging/one.csv",
  "db/ETL_Pipeline/ETL_staging/two.csv",
  "db/ETL_Pipeline/ETL_staging/three.csv",
  "db/ETL_Pipeline/ETL_staging/four.csv",
  "db/ETL_Pipeline/ETL_staging/five.csv",
  "db/ETL_Pipeline/ETL_staging/six.csv",
  "db/ETL_Pipeline/ETL_staging/seven.csv",
  "db/ETL_Pipeline/ETL_staging/eight.csv",
  "db/ETL_Pipeline/ETL_staging/nine.csv",
  "db/ETL_Pipeline/ETL_staging/ten.csv",
  "db/ETL_Pipeline/ETL_staging/eleven.csv",
]

raw_data_file = "db/ETL_Pipeline/raw_CSVs/trump_admin_debts.csv"

normalization_information = [
  ['db/ETL_Pipeline/raw_CSVs/trump_admin_debts.csv',[:department, :last_name, :first_name], 'db/ETL_Pipeline/ETL_staging/one.csv', 'db/ETL_Pipeline/ETL_staging/two.csv'],
  ['db/ETL_Pipeline/ETL_staging/one.csv',[:department], 'db/ETL_Pipeline/ETL_staging/three.csv', 'db/ETL_Pipeline/ETL_staging/four.csv'], # 3=departments, 4=employees
  ['db/ETL_Pipeline/ETL_staging/two.csv',[:lender],'db/ETL_Pipeline/ETL_staging/five.csv', 'db/ETL_Pipeline/ETL_staging/six.csv'], # 5=lenders
  ['db/ETL_Pipeline/ETL_staging/six.csv',[:debt_type],'db/ETL_Pipeline/ETL_staging/seven.csv', 'db/ETL_Pipeline/ETL_staging/eight.csv'] # 7=debt_types, 8=debts
]

normalization_information.each do |files|
  split_tables(files[0], files[1], files[2], files[3])
  if files[0] != 'db/ETL_Pipeline/raw_CSVs/trump_admin_debts.csv'
    FileUtils.mv("#{files[0]}", "db/ETL_Pipeline/ETL_trash")
  end
end



