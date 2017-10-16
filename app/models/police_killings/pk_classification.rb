module PoliceKillings
    class PkClassification < ActiveRecord::Base
      has_many :pk_deaths
    end
end