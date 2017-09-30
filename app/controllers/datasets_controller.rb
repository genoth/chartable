class DatasetsController < ApplicationController

  def show
    @departments = TrumpAdminDebts::Department.all.to_json
    @employees = TrumpAdminDebts::Employee.all.to_json
    @debts = TrumpAdminDebts::Debt.all.to_json
    @debt_types = TrumpAdminDebts::DebtType.all.to_json
    @lenders = TrumpAdminDebts::Lender.all.to_json

    @descriptor_objects = [@departments, @employees, @lenders]
    @descriptor_titles = ['Departments', 'Employees', 'Lenders']

    @numeric_objects = [@debts]
    @numeric_titles = ['Debts']
  end

  def query
    @departments = TrumpAdminDebts::Department.all
    @employees = TrumpAdminDebts::Employee.all
    @debts = TrumpAdminDebts::Debt.all
    @debt_types = TrumpAdminDebts::DebtType.all
    @lenders = TrumpAdminDebts::Lender.all

    if params[:descriptor] == "departments"
      @descriptor = @department.to_json
    elsif params[:descriptor] == "employees"
      @descriptor = @employees.to_json
    elsif params[:descriptor] == "debt_types"
      @descriptor = @debt_types.to_json
    elsif params[:descriptor] == "lenders"
      @descriptor = @lenders.to_json
    end

    respond_to do |format|
      format.text {render json: @descriptor}
    end
  end

end
