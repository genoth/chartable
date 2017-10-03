module GenderInequality
  class Query
    def initialize(params)
      @params = params
    end

    def data
      thing_we_want = GenderInequality.aggregation_sql_snippits[@params[:aggregations]]
      query = GenderInequality::GenderData.select(thing_we_want + ", country").where(thing_we_want + " IS NOT null")

      @dataset = query.map { |row| [row, row.country]}

# this works down here
#         query =  GenderInequality::GenderData.select("share_of_women_w_some_secondary_education_25_and_up_2005_2014, country").where("share_of_women_w_some_secondary_education_25_and_up_2005_2014 IS NOT null")
#         @dataset = query

      # # if @params[:descriptors] == "Country"
      # #   query = GenderInequality::GenderData
      # #     .select("#{aggregator_SQL_string}, country").where("#{aggregator_SQL_string}")
      # #     puts "****************************************"
      # #   p query
      # #   @dataset = query

      @dataset = @dataset.map { |sub_array| { label: sub_array[-1], amount: sub_array[-2][thing_we_want] } }

    end

  end
end
