module CanadianClimate
  class Query
    def initialize(params)
      @params = params
    end

    def data
      thing_we_want = CanadianClimate.aggregation_sql_snippits[@params[:aggregations]]
      query = CanadianClimate::TempYear.select(thing_we_want + ", year").where(thing_we_want + " IS NOT null")

      @dataset = query.map { |row| [row, row.year]}

      @dataset = @dataset.map { |sub_array| { label: sub_array[-1], amount: sub_array[-2][thing_we_want] } }

    end

  end
end
