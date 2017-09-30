module TrumpAdminDebts
  class Query
    def initialize(params)
    end

    def pie_chart_data
    end

  end

  class Form
    def self.descriptors
      ["Departments", "Employees", "Debt Types", "Lenders"]
    end

    def self.aggregations
      ["Minimum Debts", "Maximum Debts"]
    end
  end

end
