module CanadianClimate
  class Query
    include DataPreparer
    def initialize(params)
      @params = params
    end

    def data
      aggregator_SQL_string = CanadianClimate.aggregation_sql_snippits[@params[:aggregations]]
      if @params[:descriptors] == "Years"
        query = CanadianClimate::TempYear
          .select("#{aggregator_SQL_string}, temp_year")
          dataset = query.map{ |row| [row, row.temp_year]}
      end
       dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}
       prepared_data(dataset)
    end

    private

    def should_condense?
      false
    end

  end
end
