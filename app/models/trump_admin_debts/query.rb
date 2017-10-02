module TrumpAdminDebts
  class Query
    def initialize(params)
      @params = params
      p params
    end

    def data
      aggregator_SQL_string = TrumpAdminDebts.aggregation_sql_snippits[@params[:aggregations]]

      puts aggregator_SQL_string

      if @params[:descriptors] == "Departments"
        query = TrumpAdminDebts::Debt
<<<<<<< HEAD
          .select("#{aggregator_SQL_string}, departments.name, debts.employee_id")
          .joins(:department)
          .group("debts.employee_id, departments.name")
          p query
        @dataset = query.map { |r| [r.sum, r.department.name] }
      elsif @params[:descriptors] == "Employees"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, debts.employee_id")
          .includes(:employee)
          .group("debts.employee_id")
        @dataset = query.map { |r| [r.sum, r.employee.last_name, r.department.name] }
=======
          .select("#{aggregator_SQL_string}, departments.name AS name")
          .joins(:department)
          .group("departments.name")
        @dataset = query.map { |r| [r.sum, r.name] }

      elsif @params[:descriptors] == "Employees"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, employees.first_name || ' ' || employees.last_name AS foobar_name")
          .joins(:employee)
          .group("employees.last_name, employees.first_name")
        @dataset = query.map { |r| [r.sum, r.foobar_name] }

>>>>>>> master
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
