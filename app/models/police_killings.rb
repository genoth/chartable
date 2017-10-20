module PoliceKillings

    def self.descriptors
      ["Cause of Death", "Sexes", "Races", "States",  "Armed?"]
    end

    def self.orders # should we be able to see just a selection of the data? e.g. top 10
      ["All", "Top", "Bottom"]
    end

    def self.aggregations
      aggregation_sql_snippits.keys
    end

    def self.aggregation_sql_snippits
      {
      "Deaths" => "count(pk_deaths.id) AS deaths"
      # "Average Spring Temperature" => "spring_temperature_celsius",
      # "Average Summer Temperature" => "summer_temperature_celsius",
      # "Average Fall Temperature" => "fall_temperature_celsius"
      }
    end

    # def self.descriptor_sql_snippits
    # end

    def self.metadata
      {
      description: "This dataset of people killed by police in the U.S. highlights the frequency of police killings by race and sex.",
      dataset_title: "People Killed by Police in the US, 2016",
      sources: [
                ["The Guardian", "https://www.theguardian.com/us-news/series/counted-us-police-killings"],
                ["U.S. Census Bureau", "https://www.census.gov/data/tables/2016/demo/popest/state-total.html"],
                ["U.S. Census Bureau - QuickFacts", "https://www.census.gov/quickfacts/fact/table/US/PST045216"]
                ]
      # dataset_url: "https://www.theguardian.com/us-news/series/counted-us-police-killings",
      # dataset_source: "The Guardian, U.S. Census Bureau"
      }
    end
end