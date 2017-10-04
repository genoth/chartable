

def general_parser(file_name, namespace_table_name)
    headers = CSV.read(file_name, headers: true, header_converters: :symbol).headers

    data_hash = Hash.new

    counter_g = 0
    CSV.foreach(file_name, headers: true, header_converters: :symbol) do |row|
    counter_g += 1
    print 'g' if counter_g % 100 == 0

        headers.each do |header|
            data_hash.store(header, row[header])
        end
        namespace_table_name.create!(data_hash)
    end
end


