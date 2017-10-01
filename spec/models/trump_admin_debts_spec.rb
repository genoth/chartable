require 'rails_helper'

RSpec.describe TrumpAdminDebts, type: :model do

  describe "form inputs" do
    it "has the right descriptors" do
      expect(TrumpAdminDebts.descriptors.include?("Employees")).to be true
    end

    it "has the right aggregations"
  end

  describe "query" do
    it "has 500000 for trump's max amount when grouped by employee"
  end


end
