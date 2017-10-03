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
      description: "This dataset consists of the self-reported personal finances of President Trump and his appointees. Specifically, it is concerned with the personal debt (e.g. mortages, student loans, credit cards, and other debts) disclosed by each member of the Trump administration. These disclosures are required by the U.S. Office of Government Ethics (OGE). The OGE data displayed here was compiled by the Center for Public Integrity, in collaboration with ProPublica, and most recently updated in June 2017. This data may not reflect White House staffing changes that have occurred since that time.",
      dataset_title: "Personal Debts of President Trump and his Appointees",
      dataset_url: "http://bit.ly/2r2rFGQ",
      dataset_source: "Center for Public Integrity, ProPublica"
      }
    end
end

