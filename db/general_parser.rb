def general_parser(file_name, namespace_table_name)
    headers = CSV.read(file_name, headers: true, header_converters: :symbol).headers

    data_hash = Hash.new

    CSV.foreach(file_name, headers: true, header_converters: :symbol) do |row|
        headers.each do |header|
            data_hash.store(header, row[header])
        end
        namespace_table_name.create!(data_hash)
    end
end

# Dan's note: how are we getting away without requiring csv in this file?
