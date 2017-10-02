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
            .select("#{aggregator_SQL_string}, statistics.race_id")
            .includes(:race)
            .group("statistics.race_id")
            p query
          @dataset = query.map { |r| p r; [r.avg, r.race.race] }
      elsif @params[:descriptors] == "Sexes"
        query = USLifeExpectancy::Statistic
            .select("#{aggregator_SQL_string}, statistics.sex_id")
            .includes(:sex)
            .group("statistics.sex_id")
            p query
          @dataset = query.map { |r| p r; [r.avg, r.sex.sex] }
      elsif @params[:descriptors] == "Years"
        query = USLifeExpectancy::Statistic
            .select("#{aggregator_SQL_string}, statistics.year_id")
            .includes(:year)
            .group("statistics.year_id")
            p query
          @dataset = query.map { |r| p r; [r.avg, r.year.year] }
      end

      @dataset = @dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0] } }
    end
  end
end


