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
    if params[:descriptors] == "Departments"

      query = TrumpAdminDebts::Debt.select("sum(max_amount) as sum, employees.department_id, debts.employee_id").joins(:department).group("employees.department_id, debts.employee_id")
      @dataset = query.map { |r| [r.sum, r.department.name] }
      @dataset = @dataset.map { |sub_array| { label: sub_array[1], amount: sub_array[0] } }
    end
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
