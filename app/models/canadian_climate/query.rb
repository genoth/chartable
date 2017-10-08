module CanadianClimate
  class Query
    include DataPreparer
    def initialize(params)
      @params = params
    end

    def data
      if @params[:chart] == "scatter"
        scatter_data
      elsif @params[:chart] == "bar"
        bar_data
      end
    end

    def bar_data
      aggregator_SQL_string = CanadianClimate.aggregation_sql_snippits[@params[:aggregations]]
      if @params[:descriptors] == "Years"
        query = CanadianClimate::TempYear
          .select("#{aggregator_SQL_string}, temp_year")
          dataset = query.map{ |row| [row, row.temp_year]}
      end
       dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}
       prepared_data(dataset)
    end

    def scatter_data
      aggregator_SQL_string = CanadianClimate.aggregation_sql_snippits[@params[:aggregations]]
      if @params[:descriptors] == "Years"
        query = CanadianClimate::TempYear
          .select("#{aggregator_SQL_string}, temp_year")
          dataset = query.map{ |row| [row, row.temp_year]}
      end
       dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}

       x_years = ["x_years"]
       temps = ["Temperature"]

       dataset.each do |hash|
        x_years.push(hash[:label])
        temps.push(hash[:amount])
      end
      sending_back = []
      sending_back.push(x_years, temps)
    end

#     def scatter_data
#       aggregator_SQL_string = USLifeExpectancy.aggregation_sql_snippits[@params[:aggregations]]
#       if @descriptors == "Races" # "Races" as string
#         labels = ["All Races", "Black", "White"]
#         dataset = race_descriptor_query(aggregator_SQL_string)
#         p dataset
#         generate_scatter_data(dataset, labels)
#       elsif @descriptors == "Sexes"
#         labels = ["Both Sexes", "Female", "Male"]
#         dataset = sex_descriptor_query(aggregator_SQL_string)
#         generate_scatter_data(dataset, labels)
#       end
#     end

# # ["Statistics", "Races", "Sexes", "Years"]

#     def generate_scatter_data(dataset, labels)
#       x_axis = ["years_x"]
#       descriptor_both_id_1 = [labels[0]] #["All Races"]
#       descriptor_id_2 = [labels[1]] # ["Black"]
#       descriptor_id_3 = [labels[2]] # ["White"]
#       dataset = dataset.sort_by { |sub_array| sub_array.last } # sorting by Year, the x-axis value

#       dataset.each do |sub_array|
#         x_axis.push(sub_array[2])
#       end
#       dataset.each do |sub_array|
#         if sub_array[1] == labels[2] #"White"
#           descriptor_id_3 << sub_array[0]
#         elsif
#           sub_array[1] ==  labels[1] # "Black"
#           descriptor_id_2 << sub_array[0]
#         else
#           sub_array[1] == labels[0] # "All Races"
#           descriptor_both_id_1 << sub_array[0]
#         end
#       end
#       thing = Array.new.push(x_axis.uniq, descriptor_both_id_1, descriptor_id_2, descriptor_id_3)
#     end

    # def labels
    #   if @descriptors == "Races"
    #     ["All Races", "Black", "White"]
    #   elsif @descriptors == "Sex"
    #     ["Both Sexes", "Female", "Male"]
    #   end
    # end

    private

    def should_condense?
      false
    end

  end
end
