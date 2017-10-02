module GenderInequality
  class Query
    def initialize(params)
      @params = params
    end

    def data
      if @params[:descriptors] == "Country"
        query =  GenderInequality::GenderData.select("share_of_women_w_some_secondary_education_25_and_up_2005_2014, country").where("share_of_women_w_some_secondary_education_25_and_up_2005_2014 IS NOT null")
        p query
        @dataset = query
        puts "************************** this is the @datatset"
        p @dataset

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
      end

      p @dataset = @dataset.map { |sub_array| { label: sub_array.country, amount: sub_array.share_of_women_w_some_secondary_education_25_and_up_2005_2014 } }
    end

  end
end
