module USLifeExpectancy
  def self.descriptors
    ["Sexes", "Races"]
  end

  def self.orders
      ["All", "Top", "Bottom"]
    end

  def self.aggregations
    aggregation_sql_snippits.keys
  end

  def self.aggregation_sql_snippits
    {
      "Average Life Expectancy" => "avg(average_life_expectancy) as points"
    }
  end

  def self.metadata
      {
      description: "This dataset of U.S. mortality trends since 1900 highlights the differences in age-adjusted death rates and life expectancy at birth by race and sex.",
      dataset_title: "Death Rates and Life Expectancy at Birth",
      dataset_url: "https://data.cdc.gov/api/views/w9j2-ggv5",
      dataset_source: "CDC: National Center for Health Statistics",
      y_axis_label: "Age",
      x_axis_label: "Year"
      }
    end
end
