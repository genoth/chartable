# // this is before it comes back from the database

giant_nested_array = [[64.3666666666667, "White", 1943], [73.3333333333333, "All Races", 1977], [77.5666666666667, "All Races", 2005], [79.0666666666667, "White", 2012], [68.0666666666667, "Black", 1978], [64.9333333333333, "White", 1939], [60.2, "Black", 1948], [77.4666666666667, "White", 2001], [74.4, "White", 1980], [46.3, "Black", 1928], [64.4333333333333, "White", 1933], [71.7666666666667, "White", 1970], [64.5333333333333, "Black", 1961], [67.9666666666667, "All Races", 1949], [74.6, "Black", 2009], [72.0666666666667, "White", 1972], [76.3, "White", 1993], [61.5333333333333, "White", 1924], [70.8666666666667, "White", 1963], [73.6666666666667, "White", 1976], [70.7, "White", 1960], [77.3, "White", 2000], [52.9666666666667, "Black", 1938], [74.5666666666667, "All Races", 1983], [70.2666666666667, "All Races", 1966], [68.3, "All Races", 1950], [60.5, "All Races", 1927], [76.6666666666667, "All Races", 1999]]

new_array = giant_nested_array.sort_by { |subarray| subarray[2] }
p new_array

year_x_array = ["years_x"]

all_races = ["all_races"]
white = ["white"]
black = ["black"]

new_array.each do |sub_array|
  year_x_array.push(sub_array[2])
end

ready_to_scatter = []
new_array.each do |sub_array|
  if sub_array[1] == "White"
    white << sub_array[0]
  elsif
    sub_array[1] == "Black"
    black << sub_array[0]
  else
    sub_array[1] == "All Races"
    all_races << sub_array[0]
  end
end
    puts "Are we ready to scatter?"
    p ready_to_scatter.push(year_x_array, white, black, all_races)




# // this is what we really really want
# // ["years_x", 1900, 1901, 1902...]
# // ["All Races", 47.3, 49.1, 51.56...]
# // ["Black", 33, 33.73, 34.63...]
# // ["White", 47.6, 49.46, 51.96...]

# // array = ["years_x"]


# // label_data = {Country: "education_x"}
# //       x_axis = ["education_x"]

# //       @dataset.each do |subarray|
# //         x_axis.push(subarray[2])
# //       end
# //       full_column_list = []
# //       full_column_list.push(x_axis)

# //       @dataset.each do |subarray|
# //         full_column_list.push([subarray[1], subarray[0]])
# //       end

# //       full_column_list

# // this is after the weird json transformation
# // [{:label=>"White", :amount=>64.3666666666667, :year=>1943}, {:label=>"All Races", :amount=>73.3333333333333, :year=>1977}, {:label=>"All Races", :amount=>77.5666666666667, :year=>2005}, {:label=>"White", :amount=>79.0666666666667, :year=>2012}, {:label=>"Black", :amount=>68.0666666666667, :year=>1978}, {:label=>"White", :amount=>64.9333333333333, :year=>1939}, {:label=>"Black", :amount=>60.2, :year=>1948}, {:label=>"White", :amount=>77.4666666666667, :year=>2001}, {:label=>"White", :amount=>74.4, :year=>1980}, {:label=>"Black", :amount=>46.3, :year=>1928}, {:label=>"White", :amount=>64.4333333333333, :year=>1933}, {:label=>"White", :amount=>71.7666666666667, :year=>1970}, {:label=>"Black", :amount=>64.5333333333333, :year=>1961}, {:label=>"All Races", :amount=>67.9666666666667, :year=>1949}, {:label=>"Black", :amount=>74.6, :year=>2009}, {:label=>"White", :amount=>72.0666666666667, :year=>1972}, {:label=>"White", :amount=>76.3, :year=>1993}, {:label=>"White", :amount=>61.5333333333333, :year=>1924}, {:label=>"White", :amount=>70.8666666666667, :year=>1963},
