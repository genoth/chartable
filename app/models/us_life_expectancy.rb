module USLifeExpectancy
  def self.descriptors
    ["Races", "Sexes", "Years"]
  end

  def self.aggregations
    aggregation_sql_snippits.keys
  end

  def self.aggregation_sql_snippits
    {
      # "Age Adjusted Death Rate" =>"avg(age_adjusted_death_rate) as avg",
      "Average Life Expectancy" => "avg(average_life_expectancy) as avg"
    }
  end

end
