require 'rails_helper'

RSpec.describe 'The points request spec' do
  let!(:headers) {{"CONTENT_TYPE" => "application/json"}}
  let!(:transaction_1) { Transaction.create!(payer: "DANNON", points: 300, timestamp: DateTime.new(2022,10,31,10)) }
  let!(:transaction_2) { Transaction.create!(payer: "UNILEVER", points: 200, timestamp: DateTime.new(2022,10,31,11)) }
  let!(:transaction_3) { Transaction.create!(payer: "DANNON", points: -200, timestamp: DateTime.new(2022,10,31,15)) }
  let!(:transaction_4) { Transaction.create!(payer: "MILLER COORS", points: 10000, timestamp: DateTime.new(2022,11,01,14)) }
  let!(:transaction_5) { Transaction.create!(payer: "DANNON", points: 1000, timestamp: DateTime.new(2022,11,02,14)) }

  describe 'PATCH /api/v1/points' do
    describe 'if all params are present' do
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
    end
  end

  describe 'GET /api/v1/points' do
    let!(:transaction_1) { Transaction.create!(payer: "DANNON", points: 300, timestamp: DateTime.new(2022,10,31,10)) }
    let!(:transaction_2) { Transaction.create!(payer: "UNILEVER", points: 200, timestamp: DateTime.new(2022,10,31,11)) }
    let!(:transaction_3) { Transaction.create!(payer: "DANNON", points: -200, timestamp: DateTime.new(2022,10,31,15)) }
    let!(:transaction_4) { Transaction.create!(payer: "MILLER COORS", points: 10000, timestamp: DateTime.new(2022,11,01,14)) }
    let!(:transaction_5) { Transaction.create!(payer: "DANNON", points: 1000, timestamp: DateTime.new(2022,12,01,14)) }
    let!(:transaction_6) { Transaction.create!(payer: "DANNON", points: -100, timestamp: DateTime.new(2022,12,01,14)) }
    let!(:transaction_7) { Transaction.create!(payer: "UNILEVER", points: -200, timestamp: DateTime.new(2022,12,01,14)) }
    let!(:transaction_8) { Transaction.create!(payer: "MILLER COORS", points: -4700, timestamp: DateTime.new(2022,12,01,14)) }

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