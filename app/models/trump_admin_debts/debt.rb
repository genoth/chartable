module TrumpAdminDebts
    class Debt < ActiveRecord::Base
      belongs_to :employee
      belongs_to :lender
      belongs_to :debt_type
      has_one :department, :through => :employee

      validates :max_amount, {:numericality => {greater_than: 0}, :allow_blank => true}

      validates :min_amount, {:numericality => {greater_than: 0}, :allow_blank => false}

      def disp_min
        display_money(self.min_amount)
      end

      def correct_max
        if !max_amount.is_a?(Numeric)
          max_amount == min_amount
        end
      end

      def disp_max
        if max_amount
          display_money(self.max_amount)
        else
          "unknown"
        end
      end

      def display_money(amount)
      amount = amount.floor.to_s
        if amount.length >= 4 && amount.length < 7
          amount.insert(-4, ",")
        elsif amount.length >= 7 && amount.length < 10
          amount.insert(-7, ",")
          amount.insert(-4, ",")
        elsif amount.length >= 10 && amount.length < 13
          amount.insert(-10, ",")
          amount.insert(-7, ",")
          amount.insert(-4, ",")
        elsif amount.length >= 13 && amount.length < 16
          amount.insert(-13, ",")
          amount.insert(-10, ",")
          amount.insert(-7, ",")
          amount.insert(-4, ",")
        end
        amount = amount.insert(0, "$")
      end

  end
end
