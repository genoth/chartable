require 'csv'

def construct_sub_entity(file_name, child_table_headers)

  child_table_data = []

  CSV.foreach(file_name, headers: true, header_converters: :symbol) do |original_row|
    child_table_row = Hash.new
    child_table_headers.each do |child_table_column|
      child_table_hash.store(child_table_column, original_row[child_table_column])
      if !child_table_data.include?(child_table_hash)
        child_table_data << child_table_hash
      end
    end
  end

  CSV.open("test_destination.csv", "w") do |csv|
    child_table_data.each do |new_row|
      csv << new_row
    end
  end
  # write child_table_data to new CSV file.

end
