require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many :transactions }
  end

  describe 'validations' do
    it { should validate_presence_of :points }
    it { should validate_numericality_of :points }
  end
end
