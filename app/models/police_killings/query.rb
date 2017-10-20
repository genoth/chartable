module PoliceKillings
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
      return "Date"
    end

    def y_axis_label
      if @params[:descriptors] == "Races" || @params[:descriptors] == "States"
        return "Number of Deaths per 100,000"
      else
        return "Number of Deaths"
      end
    end

    def data
      if @params[:chart] == "bar"
        bar_data
      elsif @params[:chart] == "scatter"
        scatter_data
      elsif @params[:chart] == "pie"
        pie_data
      end
    end

    ######################################### Group-by example with multiple tables

    def data
      aggregator_SQL_string = PoliceKillings.aggregation_sql_snippits[@params[:aggregations]]

      puts aggregator_SQL_string

      if @params[:descriptors] == "Cause of Death"
        query = PoliceKillings::PkDeath
        .select("#{aggregator_SQL_string}, pk_classifications.classification AS cause")
        .joins(:pk_classification)
        .group("pk_classifications.classification")

        dataset = query.map { |r| [r.deaths, r.cause] }

      elsif @params[:descriptors] == "Sexes"
        query = PoliceKillings::PkDeath
        .select("#{aggregator_SQL_string}, pk_sexes.sex AS gender")
        .joins(:pk_sex)
        .group("pk_sexes.sex")

        dataset = query.map { |r| [r.deaths, r.gender]}

      elsif @params[:descriptors] == "Races"
        query = PoliceKillings::PkDeath
        .select("#{aggregator_SQL_string}, pk_races.race AS race")
        .joins(:pk_race)
        .group("pk_races.race")
        .order("pk_races.race ASC")

        pop_by_race = PoliceKillings::PkRace
          .select("pk_races.race, pk_races.est_pop_2016")
          .order("pk_races.race ASC")
        thing = pop_by_race.map {|r| [r.est_pop_2016, r.race]}

        interim_dataset = query.map { |r| [r.deaths.to_f, r.race]}

       dataset = []
        thing.each_with_index do |subarray, index|
          this_race = interim_dataset[index][1]
          deaths = interim_dataset[index][0]
          race_pop = subarray[0]

          if race_pop != nil
            per_100k = (deaths/race_pop * 1000000).round(2)
            dataset << [per_100k, this_race]
          end
        end
        dataset = dataset.sort_by do |subarray|
          subarray[0]
        end

          # if subarray[0] != nil

          #   per_100k = dataset[index][0] / subarray[0]
          #   race = subarray[index][0]
          #   puts "================================="
          #   p dataset[index][1]
          #   p subarray[1]
          #   puts "===================================="
          #   new_dataset << [race, per_100k]
          # end


      elsif @params[:descriptors] == "States"
        query = PoliceKillings::PkDeath
        .select("#{aggregator_SQL_string}, pk_states.state AS state")
        .joins(:pk_state)
        .group("pk_states.state")

        dataset = query.map { |r| [r.deaths, r.state]}

      elsif @params[:descriptors] == "Armed?"
        query = PoliceKillings::PkDeath
        .select("#{aggregator_SQL_string}, pk_armed_types.armed_type AS armed")
        .joins(:pk_armed_type)
        .group("pk_armed_types.armed_type")

        dataset = query.map { |r| [r.deaths, r.armed]}

      end
      dataset = dataset.map { |sub_array| {label: sub_array[1], amount: sub_array[0] }}

      return prepared_data(dataset)
    end

#     def race_descriptor_query(aggregator_SQL_string)
#       query = PoliceKillings::PkDeath
#         .select("#{aggregator_SQL_string}, pk_death.race_id, pk_death.date")
#         .includes(:pk_race)
#         .group('pk_death.race_id, pk_death.date') # race_id
#       @dataset = query.map { |r| [r.deaths, r.pk_race.race, r.pk_death.date] } # r.race.race=
#    end

#     def sex_descriptor_query(aggregator_SQL_string)
#       query = PoliceKillings::PkDeath
#           .select("#{aggregator_SQL_string}, pk_deaths.pk_sex_id, pk_deaths.date")
#           .includes(:pk_sex)
#           .group('pk_deaths.pk_sex_id, pk_deaths.date')
#       @dataset = query.map { |r| [r.deaths, r.pk_sex.sex, r.date] }
#     end

#     def scatter_data
#       aggregator_SQL_string = PoliceKillings.aggregation_sql_snippits[@params[:aggregations]]
#       if @descriptors == "Races" # "Races" as string
#         groups = ["All Races", "Black", "White", "Hispanic or Latino", "Native American", "Arab-American", "Asian or Pacific Islander", "Unknown"]
#         dataset = race_descriptor_query(aggregator_SQL_string)
#         generate_scatter_data(dataset, groups)
#       elsif @descriptors == "Sexes"
#         groups = ["Both Sexes", "Female", "Male"]
#         dataset = sex_descriptor_query(aggregator_SQL_string)
#         generate_scatter_data(dataset, groups)
#       elsif @descriptors == "States"
#         groups = ["OH", "CA", "MT", "TX", "SD", "NC", "OK", "LA", "PA", "WA", "TN", "IL", "NM", "KY", "GA", "WI", "MD", "CO", "VA", "AK", "WV", "MI", "FL", "OR", "AL", "MO", "UT", "AZ", "IN", "NV", "KS", "AR", "SC", "NE", "MA", "DC", "HI", "NJ", "NY", "MN", "IA", "CT", "MS", "ND", "VT", "RI", "ID", "ME", "NH", "WY", "DE"]
#         dataset = sex_descriptor_query(aggregator_SQL_string)
#         generate_scatter_data(dataset, groups)
#       elsif @descriptors == "Cause of Death"
#         groups = ["Gunshot", "Death in custody", "Struck by vehicle", "Taser", "Other"]
#       elsif @descriptors == "Armed?"
#         groups = ["Firearm", "Knife", "Unarmed", "Other", "Non-lethal firearm", "Vehicle", "Unknown", "Disputed"]
#       end
#     end

# # ["Statistics", "Races", "Sexes", "Years"]

#     def generate_scatter_data(dataset, groups)
#       x_axis = ["years_x"]
#       group_0_both = [groups[0]] #["All Races"]
#       group_1 = [groups[1]] # ["Black"]
#       group_2 = [groups[2]] # ["White"]
#       dataset = dataset.sort_by { |sub_array| sub_array.last } # sorting by Year, the x-axis value

#       dataset.each do |sub_array|
#         x_axis.push(sub_array[2])
#       end
#       dataset.each do |sub_array|
#         if sub_array[1] == groups[2] #"White"
#           group_2 << sub_array[0]
#         elsif
#           sub_array[1] ==  groups[1] # "Black"
#           group_1 << sub_array[0]
#         else
#           sub_array[1] == groups[0] # "All Races"
#           group_0_both << sub_array[0]
#         end
#       end
#       thing = Array.new.push(x_axis.uniq, group_0_both, group_1, group_2)
#       p thing
#       thing
#     end

#     ##################################### "Easy" data - simple x-y, no group-bys, 1 table only

#     def bar_data
#       aggregator_SQL_string = PoliceKillings.aggregation_sql_snippits[@params[:aggregations]]
#       if @params[:descriptors] == "Cause of Death"
#         query = PoliceKillings::PkDeath
#           .select("#{aggregator_SQL_string}, pk_classification_id")
#           .includes(:pk_classification)
#           .group("pk_deaths.pk_classification_id")
#           dataset = query.map{ |row| [row, row.deaths, row.pk_classification]}
#       end
#        # dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}
#        # prepared_data(dataset)

#        x_axis_values = ["x_axis_values"]
#        # example: x_years = ["x_years"]
#        y_axis_values = ["#{@params[:aggregations]}"]
#        # example temps = ["#{@params[:aggregations]}"]
#       dataset.each do |subarray|
#         x_axis_values.push(subarray[1])
#         y_axis_values.push(subarray[0][aggregator_SQL_string])
#       end
#       sending_back = []
#       sending_back.push(x_axis_values, y_axis_values)
#       p sending_back
#       sending_back
#     end

#     # def scatter_data
#     #   aggregator_SQL_string = PoliceKillings.aggregation_sql_snippits[@params[:aggregations]]
#     #     query = PoliceKillings::Death
#     #       .select("#{aggregator_SQL_string}, col_name")
#     #       dataset = query.map{ |row| [row, row.col_name]}
#     #   end
#     #    dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0][aggregator_SQL_string] }}

#     #    x_axis_values = ["x_axis_values"]
#     #    # example: x_years = ["x_years"]
#     #    y_axis_values = ["#{@params[:aggregations]}"]

#     #    dataset.each do |hash|
#     #     x_axis_values.push(hash[:label])
#     #     y_axis_values.push(hash[:amount])
#     #   end
#     #   sending_back = []
#     #   sending_back.push(x_axis_values, y_axis_values)
#     # end

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