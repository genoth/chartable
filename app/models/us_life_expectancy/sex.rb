module USLifeExpectancy
  class Sex < ActiveRecord::Base
     has_many :statistics
  end
end
