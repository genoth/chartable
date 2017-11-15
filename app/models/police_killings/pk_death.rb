module PoliceKillings
    class PkDeath < ActiveRecord::Base
      belongs_to :pk_race
      belongs_to :pk_sex
      belongs_to :pk_city
      belongs_to :pk_state
      belongs_to :pk_armed_type
      belongs_to :pk_classification
    end
end