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
end
