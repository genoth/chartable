module USLifeExpectancy
  class Query

    def initialize(params)
      @params = params
      @descriptors = @params[:descriptors]
      @aggregations = @params[:aggregations]
    end

    def data
      if @params[:chart] == "scatter"
        scatter_data
      elsif @params[:chart] == "bar"
        bar_data # right now this is never going to happen
      elsif @params[:chart] == "pie"
        pie_data # right now this is never going to happen
      end
    end

    def race_descriptor_query(aggregator_SQL_string)
      query = USLifeExpectancy::Statistic
        .select("#{aggregator_SQL_string}, statistics.race_id, statistics.year_id") # race_id
        .includes(:race) # :race
        .includes(:year)
        .group('statistics.race_id, statistics.year_id') # race_id
      @dataset = query.map { |r| [r.points, r.race.race, r.year.year] } # r.race.race=
   end

    def sex_descriptor_query(aggregator_SQL_string)
      query = USLifeExpectancy::Statistic
          .select("#{aggregator_SQL_string}, statistics.sex_id, statistics.year_id")
          .includes(:sex)
          .includes(:year)
          .group('statistics.sex_id, statistics.year_id')
      @dataset = query.map { |r| [r.points, r.sex.sex, r.year.year] }
    end

    def scatter_data
      aggregator_SQL_string = USLifeExpectancy.aggregation_sql_snippits[@params[:aggregations]]
      if @descriptors == "Races" # "Races" as string
        labels = ["All Races", "Black", "White"]
        dataset = race_descriptor_query(aggregator_SQL_string)
        generate_c3_columns(dataset, labels)
      elsif @descriptors == "Sexes"
        labels = ["Both Sexes", "Female", "Male"]
        dataset = sex_descriptor_query(aggregator_SQL_string)
        generate_c3_columns(dataset, labels)
      end
    end

# ["Statistics", "Races", "Sexes", "Years"]

    def generate_c3_columns(dataset, labels)
      x_axis = ["years_x"]
      descriptor_both_id_1 = [labels[0]] #["All Races"]
      descriptor_id_2 = [labels[1]] # ["Black"]
      descriptor_id_3 = [labels[2]] # ["White"]
      dataset = dataset.sort_by { |sub_array| sub_array.last } # sorting by Year, the x-axis value

      dataset.each do |sub_array|
        x_axis.push(sub_array[2])
      end
      dataset.each do |sub_array|
        if sub_array[1] == labels[2] #"White"
          descriptor_id_3 << sub_array[0]
        elsif
          sub_array[1] ==  labels[1] # "Black"
          descriptor_id_2 << sub_array[0]
        else
          sub_array[1] == labels[0] # "All Races"
          descriptor_both_id_1 << sub_array[0]
        end
      end
      Array.new.push(x_axis.uniq, descriptor_both_id_1, descriptor_id_2, descriptor_id_3)
    end

  end
end

    # def prepareData(@dataset, descriptors, aggregations)
    # end
    # def labels
    #   if @descriptors == "Races"
    #     ["All Races", "Black", "White"]
    #   elsif @descriptors == "Sex"
    #     ["Both Sexes", "Female", "Male"]
    #   end
    # end
