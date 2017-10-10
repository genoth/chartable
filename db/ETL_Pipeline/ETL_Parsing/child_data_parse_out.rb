require 'csv'

def construct_child_table(original_csv_file, parent_table_headers, destination_file_path)

  parent_table_data = []

  CSV.foreach(original_csv_file, headers: true, header_converters: :symbol) do |original_row|
    parent_table_row = Hash.new
    parent_table_headers.each do |parent_table_column|
      parent_table_row.store(parent_table_column, original_row[parent_table_column])
      parent_table_data << parent_table_row
      parent_table_data.uniq!
    end
  end


  original_csv_headers = CSV.read(original_csv_file, headers: true, header_converters: :symbol).headers
  child_table_headers = (original_csv_headers - parent_table_headers)

  child_table_data = []
  foreign_key_name = parent_table_headers[0].to_s
  foreign_key_name += "_fk"
  foreign_key_name_header = foreign_key_name.to_sym
  p foreign_key_name_header

  CSV.foreach(original_csv_file, headers: true, header_converters: :symbol) do |original_row|
    child_table_search_term = Hash.new
    parent_table_headers.each do |original_csv_column|
      child_table_search_term.store(original_csv_column, original_row[original_csv_column])
    end
    foreign_key_value = parent_table_data.index(child_table_search_term) + 1
    # ^ DI: beware the off by one error, no foreign keys of 0

    # Now what we have to do is clone the data from the original csv file, except with foreign key values rapced for redundant data:
    new_table_row = Hash.new
    new_table_row.store(foreign_key_name_header, foreign_key_value)
    # ^ DI real foreign key name will eventurally get passed into this method as an argument.
    child_table_headers.each do |new_table_column|
      new_table_row.store(new_table_column, original_row[new_table_column])
    end
      child_table_data << new_table_row
  end


  # Write new data into new CSV file
  child_table_headers.unshift(foreign_key_name_header)
  CSV.open(destination_file_path, "w") do |csv|
    csv << child_table_headers
    new_row_for_child_table = []
    child_table_data.each do |child_table_row|
      new_row_for_child_table = []
      child_table_row.each_key {|header| new_row_for_child_table << child_table_row[header]}
      csv << new_row_for_child_table
    end
  end
end

# original_csv_file = 'hard_coded_filepath_string'
# original_csv_file = 'db/ETL_Pipeline/raw_CSVs/trump_admin_debts.csv'
# parent_table_headers = ['hard_coded_array']
# parent_table_headers = [:department, :last_name, :first_name]
# construct_child_table(original_csv_file, parent_table_headers)
