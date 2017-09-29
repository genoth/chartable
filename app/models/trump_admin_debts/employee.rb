module TrumpAdminDebts
  class Employee < ActiveRecord::Base
    belongs_to :department
    has_many :debts
    has_many :lenders, :through => :debts
    has_many :debt_types, :through => :debts

    validates :last_name, {:presence => true}
    validates :first_name, {:presence => true}

    def self.easy_find(last_name)
      self.where("last_name like ?", "%#{last_name}%").first
    end

    def debt_type_names
      debt_types.map(&:description)
    end

    def lender_names
      self.employees.map(&:lender_names).flatten.uniq.sort
    end

#### NUMERIC total debts

    def total_min_debts
      self.debts.inject(0) {|total, debt| total += debt.min_amount}
    end

    def total_max_debts
      self.debts.inject(0) {|total, debt| total += debt.max_amount || debt.min_amount}
    end

    #### DISPLAY total debts

    def disp_total_min_debts
      display_money(total_min_debts)
    end

    def disp_total_max_debts
      display_money(total_max_debts)
    end

    def disp_total_debt_range
      "#{disp_total_min_debts} - #{disp_total_max_debts}"
    end

  end
end
