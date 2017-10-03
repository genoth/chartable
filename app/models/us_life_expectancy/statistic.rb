module USLifeExpectancy
  class Statistic < ActiveRecord::Base
    belongs_to :race
    belongs_to :sex
    belongs_to :year
  end
end

