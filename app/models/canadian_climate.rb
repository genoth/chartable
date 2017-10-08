module CanadianClimate

    def self.descriptors
      ["Years"]
    end

    def self.orders
      ["All", "Top", "Bottom"]
    end

    def self.aggregations
      aggregation_sql_snippits.keys
    end

    def self.aggregation_sql_snippits
      {
      "Average Winter Temperature" => "winter_temperature_celsius",
      "Average Spring Temperature" => "spring_temperature_celsius",
      "Average Summer Temperature" => "summer_temperature_celsius",
      "Average Fall Temperature" => "fall_temperature_celsius"
      }
    end

    def self.metadata
      {
      description: "Seasonal average temperature deviations were computed for weather stations across Canada with sufficiently long data records to allow for trend calculation and were then interpolated to a 50-kilometre spaced grid. Seasonal grid points values were averaged together to produce a seasonal time series of temperature devations representing the entire country. Seasons are defined as winter (December, January, and February), spring (March, April, and May), summer (June, July, and August) and fall (September, October, and November).",
      dataset_title: "Seasonal average temperature departures compared with the 1961–1990 reference value, Canada, 1948 to 2014",
      dataset_url: "www.ec.gc.ca/dccha-ahccd/Default.asp?lang=En&n=B1F8423A-1",
      dataset_source: "Environment and Climate Change Canada (2015) Adjusted and Homogenized Canadian Climate Data",
      x_axis_label: "Year",
      y_axis_label: "Temp. deviation (Celsius)"
      #www.ec.gc.ca/indicateurs-indicators/default.asp?lang=En was also given as a url
      }
    end
end
