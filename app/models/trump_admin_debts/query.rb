module TrumpAdminDebts
  class Query
    def initialize(params)
      @params = params
      p params
    end

    def data
      aggregator_SQL_string = TrumpAdminDebts.aggregation_sql_snippits[@params[:aggregations]]

      if @params[:descriptors] == "Departments"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, employees.department_id, debts.employee_id")
          .joins(:department)
          .group("employees.department_id, debts.employee_id")
        @dataset = query.map { |r| [r.sum, r.department.name] }
      elsif @params[:descriptors] == "Employees"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, debts.employee_id")
          .includes(:employee)
          .group("debts.employee_id")
        @dataset = query.map { |r| [r.sum, r.employee.last_name] }
      elsif @params[:descriptors] == "Debt Types"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, debts.debt_type_id")
          .includes(:debt_type)
          .group("debts.debt_type_id")
        @dataset = query.map { |r| [r.sum, r.debt_type.description] }
      elsif @params[:descriptors] == "Lenders"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, debts.lender_id")
          .includes(:lender)
          .group("debts.lender_id")
        @dataset = query.map { |r| [r.sum, r.lender.name] }
      end

      @dataset = @dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0] } }
    end

    def self.generate_title
      "#{@params[:aggregations]} of the Trump Administration by #{@params[:descriptors]}"
    end

  end
end
