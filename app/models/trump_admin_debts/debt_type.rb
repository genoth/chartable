module TrumpAdminDebts
  class DebtType < ActiveRecord::Base
    has_many :debts
    has_many :employees, :through => :debts

  end
end
