module PoliceKillings
    class PkCity < ActiveRecord::Base
      has_many :pk_deaths
    end
end