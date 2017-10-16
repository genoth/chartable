module GenderInequality
  class Query
    include DataPreparer

    def initialize(params)
      @params = params
      @descriptors = @params[:descriptors]
      @aggregations = @params[:aggregations]
    end

    def axis_labels
      {x_axis_label: x_axis_label, y_axis_label: y_axis_label}
    end

    def x_axis_label
      # define this based on your data
    end

    def y_axis_label
      # define this based on your data
    end

    def data
      if @params[:chart] == "scatter"
        scatter_data
      elsif @params[:chart] == "bar"
        bar_data
      elsif @params[:chart] == "pie"
        pie_data
      end
    end

    ######################################### Group-by example with multiple tables

    def race_descriptor_query(aggregator_SQL_string)
      query = NamespaceWrapper::Statistic
        .select("#{aggregator_SQL_string}, statistics.race_id, statistics.year_id") # race_id
        .includes(:race) # :race
        .includes(:year)
        .group('statistics.race_id, statistics.year_id') # race_id
      @dataset = query.map { |r| [r.points.round(2), r.race.race, r.year.year] } # r.race.race=
   end

    def sex_descriptor_query(aggregator_SQL_string)
      query = NamespaceWrapper::Statistic
          .select("#{aggregator_SQL_string}, statistics.sex_id, statistics.year_id")
          .includes(:sex)
          .includes(:year)
          .group('statistics.sex_id, statistics.year_id')
      @dataset = query.map { |r| [r.points.round(2), r.sex.sex, r.year.year] }
    end

    def scatter_data
      aggregator_SQL_string = NamespaceWrapper.aggregation_sql_snippits[@params[:aggregations]]
      if @descriptors == "Races" # "Races" as string
        groups = ["All Races", "Black", "White"]
        dataset = race_descriptor_query(aggregator_SQL_string)
        p dataset
        generate_scatter_data(dataset, groups)
      elsif @descriptors == "Sexes"
        groups = ["Both Sexes", "Female", "Male"]
        dataset = sex_descriptor_query(aggregator_SQL_string)
        generate_scatter_data(dataset, groups)
      end
    end

# ["Statistics", "Races", "Sexes", "Years"]

    def generate_scatter_data(dataset, groups)
      x_axis = ["years_x"]
      group_0_both = [groups[0]] #["All Races"]
      group_1 = [groups[1]] # ["Black"]
      group_2 = [groups[2]] # ["White"]
      dataset = dataset.sort_by { |sub_array| sub_array.last } # sorting by Year, the x-axis value

      dataset.each do |sub_array|
        x_axis.push(sub_array[2])
      end
      dataset.each do |sub_array|
        if sub_array[1] == groups[2] #"White"
          group_2 << sub_array[0]
        elsif
          sub_array[1] ==  groups[1] # "Black"
          group_1 << sub_array[0]
        else
          sub_array[1] == groups[0] # "All Races"
          group_0_both << sub_array[0]
        end
      end
      thing = Array.new.push(x_axis.uniq, group_0_both, group_1, group_2)
    end

    ##################################### "Easy" data - simple x-y, no group-bys, 1 table only

    def bar_data
      aggregator_SQL_string = NamespaceWrapper.aggregation_sql_snippits[@params[:aggregations]]
      if @params[:descriptors] == "Years"
        query = NamespaceWrapper::PgTable
          .select("#{aggregator_SQL_string}, col_name")
          dataset = query.map{ |row| [row, row.col_name]}
      end
       # dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}
       # prepared_data(dataset)

       x_axis_values = ["x_axis_values"]
       # example: x_years = ["x_years"]
       y_axis_values = ["#{@params[:aggregations]}"]
       # example temps = ["#{@params[:aggregations]}"]
      dataset.each do |subarray|
        x_axis_values.push(subarray[1])
        y_axis_values.push(subarray[0][aggregator_SQL_string])
      end
      sending_back = []
      sending_back.push(x_axis_values, y_axis_values)
    end

    def scatter_data
      aggregator_SQL_string = NamespaceWrapper.aggregation_sql_snippits[@params[:aggregations]]
      if @params[:descriptors] == "Years"
        query = NamespaceWrapper::PgTable
          .select("#{aggregator_SQL_string}, col_name")
          dataset = query.map{ |row| [row, row.col_name]}
      end
       dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}

       x_axis_values = ["x_axis_values"]
       # example: x_years = ["x_years"]
       y_axis_values = ["#{@params[:aggregations]}"]

       dataset.each do |hash|
        x_axis_values.push(hash[:label])
        y_axis_values.push(hash[:amount])
      end
      sending_back = []
      sending_back.push(x_axis_values, y_axis_values)
    end

    private

    def should_condense?
      false
      # Choose True or False here. How to decide: Consider whether it would make sense to show the top 10 and then group the rest into an "other" category. e.g. Debts of Trump administration by Employee- show only the top 10 and then group everyone else's debt into "109 others" If "Other" makes sense, choose True.
    end

    def should_sort_by_amount?
      false
    end
  end
end