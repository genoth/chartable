module TrumpAdminDebts

    def self.descriptors
      ["Departments", "Employees", "Debt Types", "Lenders"]
    end

    def self.aggregations
      aggregation_sql_snippits.keys
    end

    def self.aggregation_sql_snippits
      {
        "Sum Maximum Debts" => "sum(max_amount) / 1000000 as sum",
        "Sum Minimum Debts" => "sum(min_amount) / 1000000 as sum",
        "Avg Min Debt" => "avg(min_amount) / 1000000 as sum"
      }
    end

    def self.metadata
      {
      description: "This dataset consists of the self-reported personal finances of President Trump and his appointees. Specifically, the personal debt (e.g. mortages, student loans) disclosed by each member of the Trump administration as required by the U.S. Office of Government Ethics (OGE). The OGE data displayed here was most recently updated in June 2017. This data may not reflect White House staffing changes that have occurred since that time.",
      dataset_title: "Personal Debts of President Trump and his Appointees",
      dataset_url: "https://www.publicintegrity.org/2017/06/07/20910/database-trump-administration-officials-personal-finances-grows",
      dataset_source: "Center for Public Integrity"
      }
    end
end

