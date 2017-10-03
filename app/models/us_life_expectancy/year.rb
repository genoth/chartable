module USLifeExpectancy
  class Year < ActiveRecord::Base
    has_many :statistics
  end
end
