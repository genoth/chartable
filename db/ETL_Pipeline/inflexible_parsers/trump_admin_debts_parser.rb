require 'csv'
require_relative '../config/environment'

CSV.foreach("db/trump_admin_debts.csv", headers: true, header_converters: :symbol) do |row|

  department = TrumpAdminDebts::Department.find_or_create_by!(name: row[:department])
  employee = TrumpAdminDebts::Employee.find_or_create_by!(last_name: row[:last_name], first_name: row[:first_name], department: department)
  lender = TrumpAdminDebts::Lender.find_or_create_by!(name: row[:lender_name])
  debt_type = TrumpAdminDebts::DebtType.find_or_create_by!(description: row[:debt_type])

  min_amount = (row[:min_amount]).to_i
  if row[:max_amount]
    max_amount = (row[:max_amount]).to_i
  end

  debt = TrumpAdminDebts::Debt.find_or_create_by!({
    employee: employee,
    lender: lender,
    debt_type: debt_type,
    min_amount: min_amount,
    max_amount: max_amount,
    year_incurred: row[:year_incurred],
    rate: row[:rate],
    term: row[:term]
    })
end
