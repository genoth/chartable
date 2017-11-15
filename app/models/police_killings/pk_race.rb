module PoliceKillings
    class PkRace < ActiveRecord::Base
      has_many :pk_deaths
    end
end