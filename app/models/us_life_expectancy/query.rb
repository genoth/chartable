module USLifeExpectancy
  class Query
    def initialize(params)
      @params = params
      p params
    end

# ["Statistics", "Races", "Sexes", "Years"]

    def data
      aggregator_SQL_string = USLifeExpectancy.aggregation_sql_snippits[@params[:aggregations]]

      # puts aggregator_SQL_string

      if @params[:descriptors] == "Races"
        query = USLifeExpectancy::Statistic
            .select("#{aggregator_SQL_string}, statistics.race_id, statistics.year_id")
            .includes(:race)
            .includes(:year)
            .group('statistics.race_id, statistics.year_id')
          @dataset = query.map { |r| [r.points, r.race.race, r.year.year] }

      elsif @params[:descriptors] == "Sexes"
        query = USLifeExpectancy::Statistic
            .select("#{aggregator_SQL_string}, statistics.sex_id, statistics.year_id")
            .includes(:sex)
            .includes(:year)
            .group('statistics.sex_id, statistics.year_id')
            p query
          @dataset = query.map { |r| [r.points, r.sex.sex, r.year.year] }
      end
      x_axis = ["years_x"]
      all_races = ["All Races"]
      white = ["White"]
      black = ["Black"]
      @dataset = @dataset.sort_by { |subarray| subarray[2] }

      @dataset.each do |sub_array|
        x_axis.push(sub_array[2])
      end

      @dataset.each do |sub_array|
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

      full_column_list = []
      full_column_list.push(x_axis.uniq, white, black, all_races)

    end

    # def prepareData(@dataset, descriptors, aggregations)
    # end

  end
end


