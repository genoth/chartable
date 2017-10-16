module USLifeExpectancy
  class Query

    def initialize(params)
      @params = params
      @descriptors = @params[:descriptors]
      @aggregations = @params[:aggregations]
    end

    def axis_labels
      {x_axis_label: x_axis_label, y_axis_label: y_axis_label}
    end

    def x_axis_label
      return "Year"
    end

    def y_axis_label
      return "Age"
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

    def race_descriptor_query(aggregator_SQL_string)
      query = USLifeExpectancy::Statistic
        .select("#{aggregator_SQL_string}, statistics.race_id, statistics.year_id") # race_id
        .includes(:race) # :race
        .includes(:year)
        .group('statistics.race_id, statistics.year_id') # race_id
      @dataset = query.map { |r| [r.points.round(2), r.race.race, r.year.year] } # r.race.race=
   end

    def sex_descriptor_query(aggregator_SQL_string)
      query = USLifeExpectancy::Statistic
          .select("#{aggregator_SQL_string}, statistics.sex_id, statistics.year_id")
          .includes(:sex)
          .includes(:year)
          .group('statistics.sex_id, statistics.year_id')
      @dataset = query.map { |r| [r.points.round(2), r.sex.sex, r.year.year] }
    end

    def scatter_data
      aggregator_SQL_string = USLifeExpectancy.aggregation_sql_snippits[@params[:aggregations]]
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

  private

  # this currently isn't being used but might be useful in terms of making query model more dynamic. having trouble referencing groups within other definitions.
    def groups
      if @descriptors == "Races"
        ["All Races", "Black", "White"]
      elsif @descriptors == "Sex"
        ["Both Sexes", "Female", "Male"]
      end
    end

    def should_condense?
      false
    end

    def should_sort_by_amount?
      false
    end

  end
end
