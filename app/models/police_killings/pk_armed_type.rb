module PoliceKillings
    class PkArmedType < ActiveRecord::Base
      has_many :pk_deaths
    end
end