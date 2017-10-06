module TrumpAdminDebts
  class Query
    include DataPreparer

    def initialize(params)
      @params = params
      p @params
    end

    def data
      aggregator_SQL_string = TrumpAdminDebts.aggregation_sql_snippits[@params[:aggregations]]

      puts aggregator_SQL_string

      if @params[:descriptors] == "Departments"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, departments.name AS name")
          .joins(:department)
          .group("departments.name")
        dataset = query.map { |r| [r.sum, r.name] }

      elsif @params[:descriptors] == "Employees"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, employees.first_name || ' ' || employees.last_name AS foobar_name")
          .joins(:employee)
          .group("employees.last_name, employees.first_name")
        dataset = query.map { |r| [r.sum, r.foobar_name] }

      elsif @params[:descriptors] == "Debt Types"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, debts.debt_type_id")
          .includes(:debt_type)
          .group("debts.debt_type_id")
        dataset = query.map { |r| [r.sum, r.debt_type.description] }

      elsif @params[:descriptors] == "Lenders"
        query = TrumpAdminDebts::Debt
          .select("#{aggregator_SQL_string}, debts.lender_id")
          .includes(:lender)
          .group("debts.lender_id")
        dataset = query.map { |r| [r.sum, r.lender.name] }
      end

      dataset = dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0] } }

      return prepared_data(dataset)
    end

    private

    def should_condense?
      true
    end

  end
end

# def limit_n_and_others(dataset)
#       n = @params[:limit_number]
#       top_n = dataset.first(n)
#       puts "this is the top n"

#       others = dataset.slice(n, dataset.length)
#       others_condensed = ["Others"]
#       total_others = 0

#       others.each do |sub_array|
#         total_others += sub_array[1]
#       end

#       others_condensed.push(total_others)
#       all_the_things = top_ten.push(others_condensed)
#     end
