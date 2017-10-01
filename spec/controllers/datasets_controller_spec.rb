require 'rails_helper'

RSpec.describe DatasetsController, type: :controller do
  render_views
  # ^ DI 10-01-17 why did I want to do this again?

  describe "GET show" do
    it "responds with a status code of 200" do
      get :show, params: {id: 'trump'}
      # ^ DI 09-30-17 why did we need params here? This didn't work
      # get :show, {id: 'trump'}
      expect(response.code).to eq("200")
    end

    it "redirects bad requests" do
      get :show, params: {id: '1'}
      expect(response.code).to eq("302")
      expect(response).to be_redirect
      expect(response).to redirect_to('/')
    end
  end

  describe "query" do
    it "includes a label and amount for each data point" do
      # TrumpAdminDebts::DebtType.create!(description: 'Foobar')
      puts TrumpAdminDebts::DebtType.count
      post :query, params: {id: 'trump', descriptors: "Employees", aggregations: "Sum Maximum Debts"}
      data = JSON.parse(response.body)
      expect(data.first).to include("label")
      expect(data.first).to include("amount")
      # expect(response)
    end
  end


end
