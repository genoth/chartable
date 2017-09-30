require 'rails_helper'

RSpec.describe DatasetsController, type: :controller do
  let!(:debt) {Debt.create!(title: 'Imagine', artist: 'John Lennon')
end
