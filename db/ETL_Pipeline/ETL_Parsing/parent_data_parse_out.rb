require 'csv'


def construct_parent_table(original_csv_file, parent_table_headers, destination_file_path)

  parent_table_data = []

  CSV.foreach(original_csv_file, headers: true, header_converters: :symbol) do |original_row|
    parent_table_row = Hash.new
    parent_table_headers.each do |parent_table_column|
      parent_table_row.store(parent_table_column, original_row[parent_table_column])
      parent_table_data << parent_table_row
      parent_table_data.uniq!
    end
  end

  CSV.open(destination_file_path, "w") do |csv|
    csv << parent_table_headers
    new_row_for_csv = []
    parent_table_data.each do |parent_table_row|
      new_row_for_csv = []
      parent_table_row.each_key {|header| new_row_for_csv << parent_table_row[header]}
      csv << new_row_for_csv
    end
  end

end


# original_csv_file = 'db/ETL_Pipeline/raw_CSVs/trump_admin_debts.csv'
# parent_table_headers = [:department, :last_name, :first_name]
# ^ DI - why did :Department with a capital D not work?
# construct_parent_table(original_csv_file, parent_table_headers)
