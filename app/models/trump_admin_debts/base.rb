module TrumpAdminDebts
  class Base < ActiveRecord::Base
    self.abstract_class = true

    establish_connection('trump_admin_debts_db')
  end
end
