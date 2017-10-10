require 'csv'
require_relative 'child_data_parse_out'
require_relative 'parent_data_parse_out'

def split_tables(original_csv_file, parent_table_headers, parent_destination, child_destination)
  construct_parent_table(original_csv_file, parent_table_headers, parent_destination)
  construct_child_table(original_csv_file, parent_table_headers, child_destination)
end


# original_csv_file = 'db/ETL_Pipeline/raw_CSVs/trump_admin_debts.csv'
# parent_table_headers = [:department, :last_name, :first_name]
# parent_destination = 'db/ETL_Pipeline/ETL_test_destination/parent_destination.csv'
# child_destination = 'db/ETL_Pipeline/ETL_test_destination/child_destination.csv'

# split_tables(original_csv_file, parent_table_headers, parent_destination, child_destination)
