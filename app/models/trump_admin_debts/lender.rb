module TrumpAdminDebts
  class Lender < ActiveRecord::Base
    has_many :debts
    has_many :borrowers, :through => :debts, :source => :employee
    has_many :departments, :through => :borrowers


    validates :name, {:presence => true}
  end
end
