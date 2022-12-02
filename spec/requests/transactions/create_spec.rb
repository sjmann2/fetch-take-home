require 'rails_helper'

RSpec.describe 'Create transactions request' do
  let!(:headers) {{"CONTENT_TYPE" => "application/json"}}

  describe 'if all parameters are present' do
    describe 'POST /api/v1/transactions' do    
      # let!(:transaction_1) { { payer: "DANNON", points: 300, timestamp: 2022-10-31T10:00:00Z }}
      # let!(:transaction_2) { { payer: "UNILEVER", points: 200, timestamp: 2022-10-31T11:00:00Z }}
      # let!(:transaction_3) { { payer: "DANNON", points: -200, timestamp: 2022-10-31T15:00:00Z  }}
      # let!(:transaction_4) { { payer: "MILLER COORS", points: 10000, timestamp: 2022-11-01T14:00:00Z }}
      # let!(:transaction_5) { { payer: "DANNON", points: 1000, timestamp: "2022-11-02T14:00:00Z" }}
      it 'returns a response with status 201 and data from the newly created transaction' do
        body = JSON.generate(payer: "DANNON", points: 300, timestamp: "2022-10-31T10:00:00Z")
        post "/api/v1/transactions", headers: headers, params: body

        expect(response).to be_successful
        expect(response).to have_http_status(201)

        result = JSON.parse(response.body, symbolize_names: true)

        expect(result).to have_key(:data)
        expect(result[:data][:type]).to eq('transaction')
        expect(result[:data][:attributes][:payer]).to eq('DANNON')
        expect(result[:data][:attributes][:points]).to eq(300)
        expect(result[:data][:attributes][:timestamp]).to eq("2022-10-31T10:00:00.000Z")
      end
    end
  end

  describe 'if params are missing' do
    it 'returns a response with status 401 and an error message' do
      body = JSON.generate(payer: "DANNON", timestamp: "2022-10-31T10:00:00Z")

      post "/api/v1/transactions", headers: headers, params: body

      expect(response).to have_http_status(400)

      result = JSON.parse(response.body, symbolize_names: true)
      
      expect(result[:errors]).to be_an(Array)
      expect(result[:errors].first[:title]).to eq("Bad request")
      expect(result[:errors].first[:detail]).to eq(["Points can't be blank", "Points is not a number"])
    end
  end
end