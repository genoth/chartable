module TrumpAdminDebts

    def self.descriptors
      ["Departments", "Employees", "Debt Types", "Lenders"]
    end

    def self.aggregations
      aggregation_sql_snippits.keys
    end

    def self.aggregation_sql_snippits
      {
        "Sum Maximum Debts" =>"sum(max_amount) as sum",
        "Sum Minimum Debts" => "sum(min_amount) as sum",
        "Avg Min Debt" => "avg(min_amount) as sum"
      }
    end

end
