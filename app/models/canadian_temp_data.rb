module CanadianTempData

    # def self.descriptors
    #   ["Departments", "Employees", "Debt Types", "Lenders"]
    # end

    # def self.aggregations
    #   aggregation_sql_snippits.keys
    # end

    # def self.aggregation_sql_snippits
    #   {
    #     "Sum Maximum Debts" =>"sum(max_amount) / 1000000 as sum",
    #     "Sum Minimum Debts" => "sum(min_amount) / 1000000 as sum",
    #     "Avg Min Debt" => "avg(min_amount) / 1000000 as sum"
    #   }
    # end

    def self.metadata
      {
      description: "Seasonal average temperature departures compared with the 1961 1990 reference value, Canada, 1948 to 2014. Note: Seasonal average temperature departures were computed for weather stations across Canada with sufficiently long data records to allow for trend calculation and were then interpolated to a 50-kilometre spaced grid. Seasonal grid points values were averaged together to produce a seasonal time series of temperature departures representing the entire country. Seasons are defined as winter (December, January, and February), spring (March, April, and May), summer (June, July, and August) and fall (September, October, and November). Source: Environment and Climate Change Canada (2015) Adjusted and Homogenized Canadian Climate Data (www.ec.gc.ca/dccha-ahccd/Default.asp?lang=En&n=B1F8423A-1). Available on the Canadian Environmental Sustainability Indicators (www.ec.gc.ca/indicateurs-indicators/default.asp?lang=En)",
      dataset_title: "Temperature Change in Canada – Seasonal average temperature departures compared with the 1961–1990 reference value",
      dataset_url: "http://open.canada.ca/data/en/dataset/00f5bde8-fac4-431f-a0df-3ed0bf21e1dc"
      }
    end



end
