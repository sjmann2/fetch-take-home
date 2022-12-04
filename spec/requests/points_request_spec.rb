require 'rails_helper'

RSpec.describe 'The points request spec' do
  let!(:headers) {{"CONTENT_TYPE" => "application/json"}}
  let!(:transaction_1) { Transaction.create!(payer: "DANNON", points_initial: 300, points_available: 100, timestamp: DateTime.new(2022,10,31,10)) }
  let!(:transaction_2) { Transaction.create!(payer: "UNILEVER", points_initial: 200, points_available: 200, timestamp: DateTime.new(2022,10,31,11)) }
  let!(:transaction_3) { Transaction.create!(payer: "DANNON", points_initial: -200, points_available: 0, timestamp: DateTime.new(2022,10,31,15)) }
  let!(:transaction_4) { Transaction.create!(payer: "MILLER COORS", points_initial: 10000, points_available: 10000, timestamp: DateTime.new(2022,11,01,14)) }
  let!(:transaction_5) { Transaction.create!(payer: "DANNON", points_initial: 1000, points_available: 1000, timestamp: DateTime.new(2022,11,02,14)) }

  describe 'PATCH /api/v1/points' do
    it 'returns a response of the payer and the amount of points subtracted' do
      body = JSON.generate(points: 5000)

      patch '/api/v1/points', headers: headers, params: body

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      result = JSON.parse(response.body, symbolize_names: true)
      
      expect(result).to eq([
        { "payer": "DANNON", "points": -100 },
        { "payer": "UNILEVER", "points": -200 },
        { "payer": "MILLER COORS", "points": -4700 }
        ]) 
    end

    describe 'if points redeemed are greater than points available' do
      it 'returns a status 400 and an error message' do
        body = JSON.generate(points: 50000)

        patch '/api/v1/points', headers: headers, params: body
        
        expect(response).to have_http_status(400)
        
        results = JSON.parse(response.body, symbolize_names: true)

        error_message = {
                          "errors": [
                              {
                                  "status": "400",
                                  "title": "Bad request",
                                  "detail": "Insufficient balance to redeem this request"
                              }
                          ]
                      }
        expect(results).to eq(error_message)
      end
    end
  end

  describe 'GET /api/v1/points' do
    let!(:transaction_1) { Transaction.create!(payer: "DANNON", points_initial: 300, points_available: 0, timestamp: DateTime.new(2022,10,31,10)) }
    let!(:transaction_2) { Transaction.create!(payer: "UNILEVER", points_initial: 200, points_available: 0, timestamp: DateTime.new(2022,10,31,11)) }
    let!(:transaction_3) { Transaction.create!(payer: "DANNON", points_initial: -200, points_available: 0, timestamp: DateTime.new(2022,10,31,15)) }
    let!(:transaction_4) { Transaction.create!(payer: "MILLER COORS", points_initial: 10000, points_available: 5300, timestamp: DateTime.new(2022,11,01,14)) }
    let!(:transaction_5) { Transaction.create!(payer: "DANNON", points_initial: 1000, points_available: 1000, timestamp: DateTime.new(2022,12,01,14)) }
    let!(:transaction_6) { Transaction.create!(payer: "DANNON", points_initial: -100, points_available: 0, timestamp: DateTime.new(2022,12,01,14)) }
    let!(:transaction_7) { Transaction.create!(payer: "UNILEVER", points_initial: -200, points_available: 0, timestamp: DateTime.new(2022,12,01,14)) }
    let!(:transaction_8) { Transaction.create!(payer: "MILLER COORS", points_initial: -4700, points_available: 0, timestamp: DateTime.new(2022,12,01,14)) }

    it 'returns a response of the payer and points balance' do
      get '/api/v1/points'

      expect(response).to be_successful
      expect(response).to have_http_status(200)

      results = JSON.parse(response.body)

      expect(results).to eq({
        "DANNON" => 1000,
        "UNILEVER" => 0,
        "MILLER COORS" => 5300
        })
    end
  end
end