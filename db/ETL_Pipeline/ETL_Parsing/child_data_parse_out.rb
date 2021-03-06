require 'csv'

#get ride of parent_table_data as an argument, it can construct it internally
def construct_child_table(original_csv_file, parent_table_headers)

  parent_table_data = []

  CSV.foreach(file_name, headers: true, header_converters: :symbol) do |original_row|
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

  CSV.foreach(original_csv_file, headers: true, header_converters: :symbol) do |original_row|
    child_table_search_term = Hash.new
    parent_table_headers.each do |original_csv_column|
      child_table_search_term.store(original_csv_column, original_row[original_csv_column])
    end
    foreign_key_value = parent_table_data.index(child_table_search_term) + 1
    # ^ DI: beware the off by one error, no foreign keys of 0

    # Now what we have to do is clone the data from the original csv file, except for the necessary foreign key changes.
      ##########################
      # Prep data for new child table
        # make headers array for new child table (subtract parent_table_headers from original_csv_headers)
        # read an array of row hashes out of the original csv file, subtituting foreign key, where necessary

    new_table_row = Hash.new
    new_table_row.store(:foreign_key_name, foreign_key_value)
    # ^ DI real foreign key name will eventurally get passed into this method as an argument.
    child_table_headers.each do |new_table_column|
      new_table_row.store(new_table_column, original_row[new_table_column])
    end
      child_table_data << new_table_row
  end


  # Write new data into new CSV file
  child_table_headers.unshift(:foreign_key_name)
  CSV.open("db/test_destination/child_table_test_destination.csv", "w") do |csv|
    csv << child_table_headers
    new_row_for_child_table = []
    # p child_table_data
    child_table_data.each do |child_table_row|
      new_row_for_child_table = []
      child_table_row.each_key {|header| new_row_for_child_table << child_table_row[header]}
      # p new_row_for_child_table
      csv << new_row_for_child_table
    end
  end
end

# original_csv_file = 'hard_coded_filepath_string'
original_csv_file = 'db/ETL_Pipeline/raw_CSVs/trump_admin_debts.csv'
# parent_table_headers = ['hard_coded_array']
parent_table_headers = [:department, :last_name, :first_name]
# parent_table_data = ['hard_coded_array_of_hashes']
parent_table_data = [{:department=>"Department of Labor", :last_name=>"Acosta", :first_name=>"Rene Alexander"}, {:department=>"White House", :last_name=>"Amin", :first_name=>"Stacy"}, {:department=>"White House", :last_name=>"Augustine", :first_name=>"Rene I"}, {:department=>"Environmental Protection Agency", :last_name=>"Bangerter", :first_name=>"Layne"}, {:department=>"White House", :last_name=>"Bannon", :first_name=>"Steve"}, {:department=>"U.S. Trade and Development Agency", :last_name=>"Barrett", :first_name=>"Peter"}, {:department=>"Department of Housing and Urban Development", :last_name=>"Bass", :first_name=>"Deidre"}, {:department=>"Department of the Interior", :last_name=>"Bernhardt", :first_name=>"David L"}, {:department=>"White House", :last_name=>"Blase", :first_name=>"Brian C"}, {:department=>"Department of the Treasury", :last_name=>"Bohigian", :first_name=>"David"}, {:department=>"White House", :last_name=>"Bossert", :first_name=>"Thomas"}, {:department=>"Department of Housing and Urban Development", :last_name=>"Bowes", :first_name=>"Robert"}, {:department=>"White House", :last_name=>"Bremberg", :first_name=>"Andrew"}, {:department=>"Department of Energy", :last_name=>"Brouillette", :first_name=>"Danny R"}, {:department=>"Securities and Exchange Commission", :last_name=>"Carofine", :first_name=>"Christopher"}, {:department=>"Department of Housing and Urban Development", :last_name=>"Carson", :first_name=>"Benjamin"}, {:department=>"Department of Education", :last_name=>"Chamberlain", :first_name=>"Michael"}, {:department=>"Department of the Treasury", :last_name=>"Chung", :first_name=>"Jason"}, {:department=>"White House", :last_name=>"Clark", :first_name=>"Justin"}, {:department=>"Department of the Treasury", :last_name=>"Claver-Carone", :first_name=>"Mauricio"}, {:department=>"White House", :last_name=>"Cohn", :first_name=>"Gary"}, {:department=>"White House", :last_name=>"Cordish", :first_name=>"Reed"}, {:department=>"Department of Education", :last_name=>"Cox-Roush", :first_name=>"Deborah"}, {:department=>"Environmental Protection Agency", :last_name=>"Davis", :first_name=>"Patrick"}, {:department=>"White House", :last_name=>"Delrahim", :first_name=>"Makan"}, {:department=>"White House", :last_name=>"DeStefano", :first_name=>"John"}, {:department=>"Department of Education", :last_name=>"DeVos", :first_name=>"Elisabeth P"}, {:department=>"White House", :last_name=>"Diaz-Rosillo", :first_name=>"Carlos"}, {:department=>"White House", :last_name=>"Donaldson", :first_name=>"Ann"}, {:department=>"Environmental Protection Agency", :last_name=>"Dravis", :first_name=>"Samantha"}, {:department=>"Department of Education", :last_name=>"Eck", :first_name=>"Kevin"}, {:department=>"White House", :last_name=>"Eisenberg", :first_name=>"John"}, {:department=>"White House", :last_name=>"Ellis", :first_name=>"Michael"}, {:department=>"White House", :last_name=>"Epshteyn", :first_name=>"Boris"}, {:department=>"White House", :last_name=>"Ferre", :first_name=>"Helen"}, {:department=>"White House", :last_name=>"Flynn", :first_name=>"Michael"}, {:department=>"Department of Education", :last_name=>"Frendewey", :first_name=>"Matthew"}, {:department=>"White House", :last_name=>"Gast", :first_name=>"Scott"}, {:department=>"White House", :last_name=>"Goldschmidt", :first_name=>"Abe E"}, {:department=>"Environmental Protection Agency", :last_name=>"Greaves", :first_name=>"Holly"}, {:department=>"United States Agency for International Development", :last_name=>"Green", :first_name=>"Mark Andrew"}, {:department=>"White House", :last_name=>"Greenblatt", :first_name=>"Jason"}, {:department=>"White House", :last_name=>"Gribbin", :first_name=>"David"}, {:department=>"Environmental Protection Agency", :last_name=>"Gunasekara", :first_name=>"Amanda"}, {:department=>"White House", :last_name=>"Hagin", :first_name=>"Joseph"}, {:department=>"Department of Education", :last_name=>"Ham", :first_name=>"Holly"}, {:department=>"Department of Health and Human Services", :last_name=>"Hargan", :first_name=>"Eric D"}, {:department=>"White House", :last_name=>"Hassett", :first_name=>"Kevin A"}, {:department=>"Department of the Treasury", :last_name=>"Hauptman", :first_name=>"Kyle"}, {:department=>"White House", :last_name=>"Herndon", :first_name=>"Charles C"}, {:department=>"White House", :last_name=>"Hiler", :first_name=>"Jonathan"}, {:department=>"Department of Education", :last_name=>"Hudson", :first_name=>"Alexandra"}, {:department=>"Department of Education", :last_name=>"Jones", :first_name=>"Amy L"}, {:department=>"White House", :last_name=>"Juster", :first_name=>"Kenneth"}, {:department=>"White House", :last_name=>"Karem", :first_name=>"Michael J"}, {:department=>"Department of Housing and Urban Development", :last_name=>"Kasper", :first_name=>"Maren"}, {:department=>"White House", :last_name=>"Kellogg", :first_name=>"Joseph K"}, {:department=>"White House", :last_name=>"Kelly", :first_name=>"John F"}, {:department=>"White House", :last_name=>"Koenig", :first_name=>"Andrew D"}, {:department=>"Department of Education", :last_name=>"Kossack", :first_name=>"Andrew"}, {:department=>"White House", :last_name=>"Kushner", :first_name=>"Jared"}, {:department=>"Export-Import Bank of the United States", :last_name=>"Law", :first_name=>"Jesse"}, {:department=>"Department of Education", :last_name=>"Lee", :first_name=>"Ebony Letise"}, {:department=>"U.S. Trade and Development Agency", :last_name=>"Leppert", :first_name=>"Ryan"}, {:department=>"White House", :last_name=>"Liddell", :first_name=>"Chris"}, {:department=>"Federal Emergency Management Agency", :last_name=>"Long", :first_name=>"William B"}, {:department=>"White House", :last_name=>"Lotter", :first_name=>"Marc E"}, {:department=>"Department of the Treasury", :last_name=>"Maloney", :first_name=>"Andrew"}, {:department=>"White House", :last_name=>"Manigault", :first_name=>"Omarosa"}, {:department=>"Department of Education", :last_name=>"Manning", :first_name=>"James"}, {:department=>"White House", :last_name=>"Marshall", :first_name=>"Kirk R"}, {:department=>"White House", :last_name=>"Matich", :first_name=>"Nicholas T"}, {:department=>"White House", :last_name=>"McGahn", :first_name=>"Donald F"}, {:department=>"White House", :last_name=>"McGinley", :first_name=>"Bill"}, {:department=>"White House", :last_name=>"Meeks", :first_name=>"Daris"}, {:department=>"White House", :last_name=>"Meyer", :first_name=>"Joyce Y"}, {:department=>"Department of the Treasury", :last_name=>"Mkrtchian", :first_name=>"Edgar"}, {:department=>"Department of the Treasury", :last_name=>"Mnuchin", :first_name=>"Steven T"}, {:department=>"White House", :last_name=>"Morgan", :first_name=>"Matthew"}, {:department=>"White House", :last_name=>"Mulvaney", :first_name=>"John M"}, {:department=>"White House", :last_name=>"Munisteri", :first_name=>"Stephen P"}, {:department=>"Environmental Protection Agency", :last_name=>"Munoz", :first_name=>"Charles"}, {:department=>"White House", :last_name=>"Navarro", :first_name=>"Peter"}, {:department=>"White House", :last_name=>"Niceta", :first_name=>"Anna C"}, {:department=>"White House", :last_name=>"O'Hara", :first_name=>"Joan"}, {:department=>"White House", :last_name=>"Olmem", :first_name=>"Andrew"}, {:department=>"White House", :last_name=>"Paoletta", :first_name=>"Mark"}, {:department=>"Department of Housing and Urban Development", :last_name=>"Patenaude", :first_name=>"Pamela H"}, {:department=>"Department of Agriculture", :last_name=>"Perdue", :first_name=>"George E"}, {:department=>"Department of Energy", :last_name=>"Perry", :first_name=>"James Richard"}, {:department=>"Department of the Treasury", :last_name=>"Phillips", :first_name=>"Craig"}, {:department=>"White House", :last_name=>"Pitcock", :first_name=>"Joshua"}, {:department=>"Central Intelligence Agency", :last_name=>"Pompeo", :first_name=>"Michael R"}, {:department=>"White House", :last_name=>"Powell", :first_name=>"Dina"}, {:department=>"Environmental Protection Agency", :last_name=>"Pruitt", :first_name=>"Edward Scott"}, {:department=>"Department of Education", :last_name=>"Reynolds", :first_name=>"Cody"}, {:department=>"Department of Transportation", :last_name=>"Rosen", :first_name=>"Jeffrey A"}, {:department=>"Department of Commerce", :last_name=>"Ross", :first_name=>"Wilbur L"}, {:department=>"Department of the Treasury", :last_name=>"Rubinstein", :first_name=>"Reed"}, {:department=>"Department of the Treasury", :last_name=>"Sandoval", :first_name=>"Camilo"}, {:department=>"Department of Defense", :last_name=>"Scher", :first_name=>"Robert"}, {:department=>"White House", :last_name=>"Schultz", :first_name=>"James D"}, {:department=>"Environmental Protection Agency", :last_name=>"Schwab", :first_name=>"Justin"}, {:department=>"Department of Justice", :last_name=>"Sessions", :first_name=>"Jefferson B"}, {:department=>"White House", :last_name=>"Short", :first_name=>"Marc"}, {:department=>"White House", :last_name=>"Sifakis", :first_name=>"George A"}, {:department=>"White House", :last_name=>"Simms", :first_name=>"Cindy"}, {:department=>"White House", :last_name=>"Sims", :first_name=>"Cliff"}, {:department=>"Department of the Treasury", :last_name=>"Smith", :first_name=>"Andrew"}, {:department=>"White House", :last_name=>"Spicer", :first_name=>"Sean"}, {:department=>"Department of State", :last_name=>"Sullivan", :first_name=>"John J"}, {:department=>"White House", :last_name=>"Teller", :first_name=>"Paul"}, {:department=>"Department of Education", :last_name=>"Toner", :first_name=>"Jana"}, {:department=>"White House", :last_name=>"Trump", :first_name=>"Donald J"}, {:department=>"White House", :last_name=>"Westerhout", :first_name=>"Maedeleine"}, {:department=>"Department of the Air Force", :last_name=>"Wilson", :first_name=>"Heather A"}, {:department=>"Department of the Treasury", :last_name=>"Wrennall-Montes", :first_name=>"Sarah"}, {:department=>"Department of Education", :last_name=>"Young", :first_name=>"Patrick"}, {:department=>"Department of the Interior", :last_name=>"Zinke", :first_name=>"Ryan"}]
construct_child_table(original_csv_file, parent_table_headers, parent_table_data)
