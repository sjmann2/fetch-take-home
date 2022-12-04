require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of :payer }
    it { should validate_presence_of :points_initial }
    it { should validate_presence_of :points_available }
    it { should validate_numericality_of :points_initial }
    it { should validate_numericality_of :points_available }
  end

  describe 'class methods' do
    describe 'spend_points' do
      let!(:transaction_1) { Transaction.create!(payer: "DANNON", points_initial: 300, points_available: 100, timestamp: DateTime.new(2022,10,31,10)) }
      let!(:transaction_2) { Transaction.create!(payer: "UNILEVER", points_initial: 200, points_available: 200, timestamp: DateTime.new(2022,10,31,11)) }
      let!(:transaction_3) { Transaction.create!(payer: "DANNON", points_initial: -200, points_available: 0, timestamp: DateTime.new(2022,10,31,15)) }
      let!(:transaction_4) { Transaction.create!(payer: "MILLER COORS", points_initial: 10000, points_available: 10000, timestamp: DateTime.new(2022,11,01,14)) }
      let!(:transaction_5) { Transaction.create!(payer: "DANNON", points_initial: 1000, points_available: 1000, timestamp: DateTime.new(2022,11,02,14)) }
  
      it 'updates transactions starting with oldest timestamp to redeem requested points, update available points, and return points spent' do
        expect(Transaction.spend_points(5000)).to eq([
          { "payer": "DANNON", "points": -100 },
          { "payer": "UNILEVER", "points": -200 },
          { "payer": "MILLER COORS", "points": -4700 }
          ]) 

        expect(Transaction.order(:timestamp).first.points_available).to eq(0)
      end

      it 'does not spend the same points twice' do
        expect(Transaction.spend_points(100)).to eq([
          { "payer": "DANNON", "points": -100 }
          ]) 
        expect(Transaction.spend_points(100)).to eq([
          { "payer": "UNILEVER", "points": -100 }
          ]) 
      end
    end

    describe 'insufficient_points?' do
      let!(:transaction_1) { Transaction.create!(payer: "DANNON", points_initial: 300, points_available: 300, timestamp: DateTime.new(2022,10,31,10)) }
      let!(:transaction_2) { Transaction.create!(payer: "UNILEVER", points_initial: 200, points_available: 200, timestamp: DateTime.new(2022,10,31,11)) }
      let!(:transaction_3) { Transaction.create!(payer: "DANNON", points_initial: -200, points_available: 0, timestamp: DateTime.new(2022,10,31,15)) }
      let!(:transaction_4) { Transaction.create!(payer: "MILLER COORS", points_initial: 10000, points_available: 10000, timestamp: DateTime.new(2022,11,01,14)) }
      let!(:transaction_5) { Transaction.create!(payer: "DANNON", points_initial: 1000, points_available: 1000, timestamp: DateTime.new(2022,12,01,14)) }
      it 'returns false if there are not enough available points to fulfill the request' do
        expect(Transaction.sufficient_points?(50000)).to eq(false)
      end

      it 'returns true if there are enough available points to fulfill the request' do
        expect(Transaction.sufficient_points?(5000)).to eq(true)
      end
    end

    describe 'get_points' do
      let!(:transaction_1) { Transaction.create!(payer: "DANNON", points_initial: 300, points_available: 0, timestamp: DateTime.new(2022,10,31,10)) }
      let!(:transaction_2) { Transaction.create!(payer: "UNILEVER", points_initial: 200, points_available: 0, timestamp: DateTime.new(2022,10,31,11)) }
      let!(:transaction_3) { Transaction.create!(payer: "DANNON", points_initial: -200, points_available: 0, timestamp: DateTime.new(2022,10,31,15)) }
      let!(:transaction_4) { Transaction.create!(payer: "MILLER COORS", points_initial: 10000, points_available: 5300, timestamp: DateTime.new(2022,11,01,14)) }
      let!(:transaction_5) { Transaction.create!(payer: "DANNON", points_initial: 1000, points_available: 1000, timestamp: DateTime.new(2022,12,01,14)) }
      let!(:transaction_6) { Transaction.create!(payer: "DANNON", points_initial: -100, points_available: 0, timestamp: DateTime.new(2022,12,01,14)) }
      let!(:transaction_7) { Transaction.create!(payer: "UNILEVER", points_initial: -200, points_available: 0, timestamp: DateTime.new(2022,12,01,14)) }
      let!(:transaction_8) { Transaction.create!(payer: "MILLER COORS", points_initial: -4700, points_available: 0, timestamp: DateTime.new(2022,12,01,14)) }
      it 'returns all payers and their current total number of points' do
        expect(Transaction.get_points).to eq(
          {
          "DANNON" => 1000,
          "UNILEVER" => 0,
          "MILLER COORS" => 5300
          })
      end
    end
  end
end
