module PoliceKillings
    class PkState < ActiveRecord::Base
      has_many :pk_deaths
    end
end