require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :payer }
    it { should validate_presence_of :points }
    it { should validate_numericality_of :points }
  end
end
