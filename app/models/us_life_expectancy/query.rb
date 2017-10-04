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

      @dataset = @dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0], year:sub_array[2] } }
    end
  end
end


