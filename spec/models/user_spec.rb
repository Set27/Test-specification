require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:patronymic) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:nationality) }
    it { should validate_presence_of(:gender) }

    it { should validate_uniqueness_of(:email) }

    it { should validate_inclusion_of(:age).in_range(1..90).with_message("must be between 1 and 90") }

    it { should allow_values('male', 'female').for(:gender) }
    it { should_not allow_values('other', 'unknown').for(:gender) }
  end

  describe 'associations' do
    it { should have_many(:user_interests).dependent(:destroy) }
    it { should have_many(:interests).through(:user_interests) }

    it { should have_many(:user_skills).dependent(:destroy) }
    it { should have_many(:skills).through(:user_skills) }
  end

  describe 'custom methods' do
    it 'returns the full name' do
      user = build(:user, name: 'John', patronymic: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end
end
