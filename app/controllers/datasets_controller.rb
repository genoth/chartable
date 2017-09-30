class DatasetsController < ApplicationController

  def show
    @departments = TrumpAdminDebts::Department.all.to_json
    @employees = TrumpAdminDebts::Employee.all.to_json
    @debts = TrumpAdminDebts::Debt.all.to_json
    @debt_types = TrumpAdminDebts::DebtType.all.to_json
    @lenders = TrumpAdminDebts::Lender.all.to_json
  end
end
