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

    def prepared_data(dataset)
      limit_n_and_others(sorted_by_amount(full_series(dataset)))
    end

    def full_series(dataset)
      dataset.map {|hash| [hash[:label], hash[:amount]]}
    end

    def sorted_by_amount(dataset)
      sorted_dataset = dataset.sort_by { |sub_array| sub_array[1] }
      sorted_dataset.reverse
    end

    def limit_n_and_others(dataset)

      limit_selected = (@params[:limit]).to_i

      if @params[:order] == "top"
        limit_n = dataset.first(limit_selected)
        others = dataset.slice(limit_selected, dataset.length)
        total_sum_others = others.reduce {|sum, sub_array| sub_array[1] }
        number_of_others = others.length
        others_condensed = [ "#{number_of_others} Others"]
        others_condensed.push(total_sum_others)
        return limit_n.push(others_condensed)

      elsif @params[:order] == "bottom"
        return dataset.last(limit_selected)
      end

    end

    def select_limit
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
