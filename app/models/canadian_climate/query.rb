module CanadianClimate
  class Query
    def initialize(params)
      @params = params
    end

    def data
      aggregator_SQL_string = CanadianClimate.aggregation_sql_snippits[@params[:aggregations]]
      if @params[:descriptors] == "Years"
        query = CanadianClimate::TempYear
          .select("#{aggregator_SQL_string}, temp_year")
          @dataset = query.map{ |row| [row, row.temp_year]}
      end
      p @dataset
       @dataset = @dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}
    end

  end
end
