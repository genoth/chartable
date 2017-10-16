module PoliceKillings
    class PkSex < ActiveRecord::Base
      has_many :pk_deaths
    end
end