module CanadianClimate
  class Query
    include DataPreparer

    def initialize(params)
      @params = params
    end

    def axis_labels
      {x_axis_label: x_axis_label, y_axis_label: y_axis_label}
    end

    def x_axis_label
      return "Year"
    end

    def y_axis_label
      return "Deviation from Average"
    end

    def data
      if @params[:chart] == "scatter"
        scatter_data
      elsif @params[:chart] == "bar"
        bar_data
      end
    end

    def bar_data
      aggregator_SQL_string = CanadianClimate.aggregation_sql_snippits[@params[:aggregations]]
      if @params[:descriptors] == "Years"
        query = CanadianClimate::TempYear
          .select("#{aggregator_SQL_string}, temp_year")
          dataset = query.map{ |row| [row, row.temp_year]}
      end
       # dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}
       # prepared_data(dataset)

       x_years = ["x_years"]
       temps = ["#{@params[:aggregations]}"]
      dataset.each do |thing|
        x_years.push(thing[1])
        temps.push(thing[0][aggregator_SQL_string])
      end
      sending_back = []
      sending_back.push(x_years, temps)
    end

    def scatter_data
      aggregator_SQL_string = CanadianClimate.aggregation_sql_snippits[@params[:aggregations]]
      if @params[:descriptors] == "Years"
        query = CanadianClimate::TempYear
          .select("#{aggregator_SQL_string}, temp_year")
          dataset = query.map{ |row| [row, row.temp_year]}
      end
       dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}

       x_years = ["x_years"]
       temps = ["Temperature"]

       dataset.each do |hash|
        x_years.push(hash[:label])
        temps.push(hash[:amount])
      end
      sending_back = []
      sending_back.push(x_years, temps)
    end

    private

    def should_condense?
      false
    end

    def should_sort_by_amount?
      false
    end

  end
end
