require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of :payer }
    it { should validate_presence_of :points }
    it { should validate_numericality_of :points }
  end

  describe 'class methods' do
    describe 'spend_points' do
      let!(:transaction_1) { Transaction.create!(payer: "DANNON", points: 300, timestamp: DateTime.new(2022,10,31,10)) }
      let!(:transaction_2) { Transaction.create!(payer: "UNILEVER", points: 200, timestamp: DateTime.new(2022,10,31,11)) }
      let!(:transaction_3) { Transaction.create!(payer: "DANNON", points: -200, timestamp: DateTime.new(2022,10,31,15)) }
      let!(:transaction_4) { Transaction.create!(payer: "MILLER COORS", points: 10000, timestamp: DateTime.new(2022,11,01,14)) }
      let!(:transaction_5) { Transaction.create!(payer: "DANNON", points: 1000, timestamp: DateTime.new(2022,11,02,14)) }
  
      it 'updates transactions starting with oldest timestamp to remove points until the points balance is zero' do
        expect(Transaction.spend_points(5000)).to eq([
          { "payer": "DANNON", "points": -100 },
          { "payer": "UNILEVER", "points": -200 },
          { "payer": "MILLER COORS", "points": -4700 }
          ])
        end
    end
  end
end
