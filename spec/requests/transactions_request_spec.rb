require 'rails_helper'

RSpec.describe 'Create transactions request' do
  let!(:headers) {{"CONTENT_TYPE" => "application/json"}}

  describe 'if all parameters are present' do
    describe 'POST /api/v1/transactions' do    
      it 'returns a response with status 201 and data from the newly created transaction' do
        body = JSON.generate(payer: "DANNON", points: 300, timestamp: "2022-10-31T10:00:00Z")
        post "/api/v1/transactions", headers: headers, params: body

        expect(response).to be_successful
        expect(response).to have_http_status(201)

        result = JSON.parse(response.body, symbolize_names: true)

        attributes = {
                  "payer": "DANNON",
                  "points": 300,
                  "timestamp": "2022-10-31T10:00:00.000Z"
                    }
    
        expect(result[:data][:attributes]).to eq(attributes)
      end
    end
  end

  describe 'if params are missing' do
    it 'returns a response with status 401 and an error message' do
      body = JSON.generate(payer: "DANNON", timestamp: "2022-10-31T10:00:00Z")

      post "/api/v1/transactions", headers: headers, params: body

      expect(response).to have_http_status(400)

      result = JSON.parse(response.body, symbolize_names: true)
      
      error_response = {
                          "errors": [
                              {
                                  "status": "400",
                                  "title": "Bad request",
                                  "detail": "Error saving transaction"
                              }
                          ]
                      }
      expect(result).to eq(error_response)
    end
  end
end