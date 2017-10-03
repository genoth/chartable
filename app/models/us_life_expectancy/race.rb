module USLifeExpectancy
  class Race < ActiveRecord::Base
     has_many :statistics
  end
end
