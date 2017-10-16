module PoliceKillings

    def self.descriptors
      ["Years"]
    end

    def self.orders # should we be able to see just a selection of the data? e.g. top 10
      ["All", "Top", "Bottom"]
    end

    def self.aggregations
      aggregation_sql_snippits.keys
    end

    def self.aggregation_sql_snippits
      {
      "Display nicely for user" => "matches_col_name_in_db",
      # "Average Winter Temperature" => "winter_temperature_celsius",
      # "Average Spring Temperature" => "spring_temperature_celsius",
      # "Average Summer Temperature" => "summer_temperature_celsius",
      # "Average Fall Temperature" => "fall_temperature_celsius"
      }
    end

    def self.metadata
      {
      description: "This dataset of people killed by police in the U.S. highlights the frequency of police killings by race and sex.",
      dataset_title: "People Killed by Police in the US, 2016",
      dataset_url: "https://www.theguardian.com/us-news/series/counted-us-police-killings",
      dataset_source: "The Guardian"
      }
    end
end