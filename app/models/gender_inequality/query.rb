module GenderInequality
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

    def education_descriptor_query(aggregator_SQL_string)
      query = GenderInequality::GenderData
      .select("#{aggregator_SQL_string}, country, gender_inequality_index_2014")
      .where("gender_inequality_index_2014 IS NOT null").where("share_of_women_w_some_secondary_education_25_and_up_2005_2014 IS NOT null")
        .group('country, share_of_women_w_some_secondary_education_25_and_up_2005_2014')
      p query
        p dataset = query.map { |result| [result.gender_inequality_index_2014, result.country, result.share_of_women_w_some_secondary_education_25_and_up_2005_2014] }
      end

    def scatter_data
      aggregator_SQL_string = USLifeExpectancy.aggregation_sql_snippits[@params[:aggregations]]
        labels = ["Country"]
        dataset = education_descriptor_query(aggregator_SQL_string)
        puts "this is the dataset"
        p dataset
        generate_c3_columns(dataset, labels)
    end

    def generate_c3_columns(dataset, labels)
      label_data = {Country: "education_x"}
      x_axis = ["education_x"]
      descriptor_id = [labels[0]]
      datset = dataset.sort_by { |sub_array| sub_array.last }
      p dataset
      dataset.each do |sub_array|
        x_axis.push(sub_array)
      end
      dataset.each do |sub_array|
        if sub_array[0] == discriptor_id
            descriptor_id << sub_array[0]
        end
      end
      new_array = Array.new(push(x_axis, descriptor_id))
      p new_array
    end


    def bar_data
      thing_we_want = GenderInequality.aggregation_sql_snippits[@params[:aggregations]]
      query = GenderInequality::GenderData.select(thing_we_want + ", country").where(thing_we_want + " IS NOT null")

      @dataset = query.map { |row| [row, row.country]}

      @dataset = @dataset.map { |sub_array| { label: sub_array[-1], amount: sub_array[-2][thing_we_want] } }
    end

    # def scatter_data
    #   aggregator_SQL_string = GenderInequality.aggregation_sql_snippits[@params[:aggregations]]

    #   if @params[:descriptors] == "Country"
    #     query = GenderInequality::GenderData
    #     .select("gender_inequality_index_rank_2014, country, share_of_women_w_some_secondary_education_25_and_up_2005_2014")
    #     @dataset = query.map { |result| [result.country] }
    #   end
    # end

  end
end
