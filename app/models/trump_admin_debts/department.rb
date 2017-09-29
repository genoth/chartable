module TrumpAdminDebts
  class Department < ActiveRecord::Base
    has_many :employees
    has_many :debts, :through => :employees
    has_many :lenders, :through => :debts

    validates :name, {:presence => true}

    def self.easy_find(lname)
      self.where("name like ?", "%#{name}%").first
    end

    def lender_names
      employees.map(&:lender_names).flatten.uniq.sort
    end

  #### NUMERIC total debts

    def total_min_debts
      employees.inject(0) {|total, employee| total + employee.total_min_debts}
    end

    def total_max_debts
      employees.inject(0) {|total, employee| total + employee.total_max_debts || total_min_debts}
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

  #### Average total debts per employee

    def average_min_debts
      self.total_min_debts/self.employees.count
    end

    def average_max_debts
      self.total_max_debts/self.employees.count
    end

#### DISPLAY average total debts per employee

    def disp_average_min_debts
      display_money(average_min_debts)
    end

    def disp_average_max_debts
      display_money(average_max_debts)
    end

  end
end
