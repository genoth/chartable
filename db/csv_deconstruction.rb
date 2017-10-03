require 'csv'


def construct_sub_entity(file_name, child_table_headers)

  child_table_data = []

  CSV.foreach(file_name, headers: true, header_converters: :symbol) do |original_row|
    child_table_row = Hash.new
    child_table_headers.each do |child_table_column|
      child_table_row.store(child_table_column, original_row[child_table_column])
      if !child_table_data.include?(child_table_row)
        child_table_data << child_table_row
      end
    end
  end

  header_string = ""
  child_table_headers.each_key { |header| header_string += header.to_s + ","}
  header_string.slice!(-1)

  CSV.open("db/test_destination.csv", "w") do |csv|
    child_table_data.each do |new_row|
      csv << header_string

      #csv << new_row
    end
  end
  # write child_table_data to new CSV file.

end


filename = 'db/trump_admin_debts.csv'
child_table_headers = [:Department, :last_name, :first_name]
construct_sub_entity(filename, child_table_headers)
