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

    def deaths_per_100k(deaths_by_group, pop_by_group)
      dataset = []
      pop_by_group.each_with_index do |subarray, index|
        this_subgroup = deaths_by_group[index][1]
        deaths = deaths_by_group[index][0]
        group_pop = subarray[0]
        if group_pop != nil
          per_100k = (deaths/group_pop * 100000).round(4)
          dataset << [per_100k, this_subgroup]
        end
      end
      dataset.sort_by do |subarray|
        subarray[0]
      end
    end

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
        mapped_pop_by_race = pop_by_race.map {|result| [result.est_pop_2016, result.race]}
        deaths_by_race = query.map { |result| [result.deaths.to_f, result.race]}

        dataset = deaths_per_100k(deaths_by_race, mapped_pop_by_race)

      elsif @params[:descriptors] == "States"
        query = PoliceKillings::PkDeath
        .select("#{aggregator_SQL_string}, pk_states.state AS state")
        .joins(:pk_state)
        .group("pk_states.state")
        .order("pk_states.state ASC")

        pop_by_state = PoliceKillings::PkState
          .select("pk_states.state, pk_states.total_pop_2016")
          .order("pk_states.state ASC")
        mapped_pop_by_state = pop_by_state.map {|result| [result.total_pop_2016, result.state]}
        deaths_by_state = query.map { |result| [result.deaths.to_f, result.state]}

        dataset = deaths_per_100k(deaths_by_state, mapped_pop_by_state)

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

    private

    def should_condense?
      false
    end

    def should_sort_by_amount?
      false
    end
  end
end