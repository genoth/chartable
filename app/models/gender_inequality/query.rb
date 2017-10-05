module GenderInequality
  class Query
    def initialize(params)
      @params = params
    end

    def data
      aggregator_SQL_string = GenderInequality.aggregation_sql_snippits[@params[:aggregations]]

      if @params[:descriptors] == "Country"
        query = GenderInequality::GenderData
        .select("gender_inequality_index_2014, country, share_of_women_w_some_secondary_education_25_and_up_2005_2014").where("gender_inequality_index_2014 IS NOT null").where("share_of_women_w_some_secondary_education_25_and_up_2005_2014 IS NOT null")
        p query
        @dataset = query.map { |result| [result.gender_inequality_index_2014, result.country, result.share_of_women_w_some_secondary_education_25_and_up_2005_2014] }
      end
      label_data = {Country: "education_x"}
      x_axis = ["education_x"]

      @dataset.each do |subarray|
        x_axis.push(subarray[2])
      end
      full_column_list = []
      full_column_list.push(x_axis)

      @dataset.each do |subarray|
        full_column_list.push([subarray[1], subarray[0]])
      end

      full_column_list
      # thing_we_want = GenderInequality.aggregation_sql_snippits[@params[:aggregations]]
      # query = GenderInequality::GenderData.select(thing_we_want + ", country").where(thing_we_want + " IS NOT null")

      # @dataset = query.map { |row| [row, row.country]}

      # @dataset = @dataset.map { |sub_array| { label: sub_array[-1], amount: sub_array[-2][thing_we_want] } }
    end

    def pie_data
    end

    def bar_data
    end

    def scatter_data
      aggregator_SQL_string = GenderInequality.aggregation_sql_snippits[@params[:aggregations]]

      if @params[:descriptors] == "Country"
        query = GenderInequality::GenderData
        .select("gender_inequality_index_rank_2014, country, share_of_women_w_some_secondary_education_25_and_up_2005_2014")
        @dataset = query.map { |result| [result.country] }
      end
    end

  end
end
