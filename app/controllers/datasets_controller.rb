class DatasetsController < ApplicationController
# get the form
  def show
    p descriptors = TrumpAdminDebts::Form.descriptors
    @diagram_form_inputs = {
      pie: {
        descriptors: TrumpAdminDebts::Form.descriptors,#[:departments, :employees]
        aggregations: TrumpAdminDebts::Form.aggregations # [:max_debts, :avg_debts]
        # filters: {
        #   :departments => Trump::Department.all
        #   :employees => Employee.all
        # },
      },
      bar: {
        descriptors: TrumpAdminDebts::Form.descriptors,#[:departments, :employees],
        aggregation: TrumpAdminDebts::Form.aggregations # [:max_debts, :avg_debts]
      }
    }
  end


  def query
    aggregator_table = {"Minimum Debts" =>"sum(max_amount) as sum", "Maximum Debts" => "sum(min_amount) as sum"}

    aggregatior_SQL_string = aggregator_table[params[:aggregations]]

    if params[:descriptors] == "Departments"
      query = TrumpAdminDebts::Debt
        .select("#{aggregatior_SQL_string}, employees.department_id, debts.employee_id")
        .joins(:department)
        .group("employees.department_id, debts.employee_id")
      @dataset = query.map { |r| [r.sum, r.department.name] }
    elsif params[:descriptors] == "Employees"
      query = TrumpAdminDebts::Debt
        .select("#{aggregatior_SQL_string}, debts.employee_id")
        .includes(:employee)
        .group("debts.employee_id")
      @dataset = query.map { |r| [r.sum, r.employee.last_name] }
    elsif params[:descriptors] == "Debt Types"
      query = TrumpAdminDebts::Debt
        .select("#{aggregatior_SQL_string}, debts.debt_type_id")
        .includes(:debt_type)
        .group("debts.debt_type_id")
      @dataset = query.map { |r| [r.sum, r.debt_type.description] }
    elsif params[:descriptors] == "Lenders"
      query = TrumpAdminDebts::Debt
        .select("#{aggregatior_SQL_string}, debts.lender_id")
        .includes(:lender)
        .group("debts.lender_id")
      @dataset = query.map { |r| [r.sum, r.lender.name] }
    end

    @dataset = @dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0] } }
    render json: @dataset
  end

end



    # elsif params[:descriptors] == "Employees"
    #   @descriptor = TrumpAdminDebts::Employee.all
    # elsif params[:descriptors] == "Debt Types"
    #   @descriptor = TrumpAdminDebts::DebtType.all
    # elsif params[:descriptors] == "Lenders"
    #   @descriptor = TrumpAdminDebts::Lender.all
    # end

    # if params[:aggregations] == "Maximum Debts"
    #   @aggregation = TrumpAdminDebts::Debts.all.to_json
    # end
    # dataset = [
    #          { label: 'White House', amount: 348085155 },
    #          { label: 'Department of Labor', amount: 1030004 },
    #          { label: 'Department of Education', amount: 3485019 },
    #          { label: 'Department of Treasury', amount: 10200036 }
    #        ]

    # render 'partials/_visualize'
    # render json: @descriptor
    # render json: @aggregations

# if params[:descriptors] == "Departments"
#       query = TrumpAdminDebts::Debt
#         .select("sum(max_amount) as sum, employees.department_id")
#         .joins(:employee)
#         .group("employees.department_id")

#       @dataset = query.map { |r| [r.sum, r.department_id] }
