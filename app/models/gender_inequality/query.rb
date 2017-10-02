module GenderInequality
  class Query
    def initialize(params)
      @params = params
    end

    def data
      aggregator_SQL_string = GenderInequality.aggregation_sql_snippits[@params[:aggregations]]

      if @params[:descriptors] == "Country"
        query =  GenderInequality::GenderData.select(
          "#{aggregator_SQL_string}, country").where("#{aggregator_SQL_string} IS NOT null")
        @dataset = query.map { |result| [result]}
        # @dataset = [
        #   [GenderInequality::GenderData id: nil, country: "Quatar", share_of_women: 66.7]
        #   [GenderInequality::GenderData id: nil, country: "Yemen", share_of_women: 8.6]
        # ]
        new_array = @dataset.map do |sub_array|
          [ sub_array[1].country, sub_array[2].aggregator_SQL_string]
        end
        p new_array

      # if @params[:descriptors] == "Country"
      #   query = GenderInequality::GenderData
      #     .select("#{aggregator_SQL_string}, country").where("#{aggregator_SQL_string}")
      #     puts "****************************************"
      #   p query
      #   @dataset = query
        # GenderInequality.aggregation_sql_snippits[@params[:aggregations]]
      # elsif @params[:descriptors] == "Departments"
      #   query = GenderInequality::Debt
      #     .select("#{aggregator_SQL_string}, departments.name AS name")
      #     .joins(:department)
      #     .group("departments.name")
      #   @dataset = query.map { |r| [r.sum, r.name] }

      # elsif @params[:descriptors] == "Employees"
      #   query = GenderInequality::Debt
      #     .select("#{aggregator_SQL_string}, employees.first_name || ' ' || employees.last_name AS foobar_name")
      #     .joins(:employee)
      #     .group("employees.last_name, employees.first_name")
      #   @dataset = query.map { |r| [r.sum, r.foobar_name] }

      # elsif @params[:descriptors] == "Debt Types"
      #   query = GenderInequality::Debt
      #     .select("#{aggregator_SQL_string}, debts.debt_type_id")
      #     .includes(:debt_type)
      #     .group("debts.debt_type_id")
      #   @dataset = query.map { |r| [r.sum, r.debt_type.description] }

      # elsif @params[:descriptors] == "Lenders"
      #   query = GenderInequality::Debt
      #     .select("#{aggregator_SQL_string}, debts.lender_id")
      #     .includes(:lender)
      #     .group("debts.lender_id")
      #   @dataset = query.map { |r| [r.sum, r.lender.name] }


      @dataset = @dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0] } }
    end

  end
end
end
