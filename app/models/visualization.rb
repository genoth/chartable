class Visualization < ActiveRecord::Base

  validates :link, {uniqueness: true}
end