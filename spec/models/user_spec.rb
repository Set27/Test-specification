require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a patronymic' do
      user.patronymic = nil
      expect(user).not_to be_valid
      expect(user.errors[:patronymic]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid without an age' do
      user.age = nil
      expect(user).not_to be_valid
      expect(user.errors[:age]).to include("can't be blank")
    end

    it 'is not valid without a nationality' do
      user.nationality = nil
      expect(user).not_to be_valid
      expect(user.errors[:nationality]).to include("can't be blank")
    end

    it 'is not valid without a gender' do
      user.gender = nil
      expect(user).not_to be_valid
      expect(user.errors[:gender]).to include("can't be blank")
    end

    it 'is not valid with a duplicate email' do
      create(:user, email: 'test@example.com')
      user.email = 'test@example.com'
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is not valid with an age less than 1' do
      user.age = 0
      expect(user).not_to be_valid
      expect(user.errors[:age]).to include('must be between 1 and 90')
    end

    it 'is not valid with an age greater than 90' do
      user.age = 91
      expect(user).not_to be_valid
      expect(user.errors[:age]).to include('must be between 1 and 90')
    end

    it 'is not valid with an invalid gender' do
      user.gender = 'other'
      expect(user).not_to be_valid
      expect(user.errors[:gender]).to include('must be either \'male\' or \'female\'')
    end
  end

  describe 'associations' do
    it 'has many user_interests' do
      association = described_class.reflect_on_association(:user_interests)
      expect(association.macro).to eq :has_many
    end

    it 'has many interests through user_interests' do
      association = described_class.reflect_on_association(:interests)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :user_interests
    end

    it 'has many user_skills' do
      association = described_class.reflect_on_association(:user_skills)
      expect(association.macro).to eq :has_many
    end

    it 'has many skills through user_skills' do
      association = described_class.reflect_on_association(:skills)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :user_skills
    end
  end

  describe 'custom methods' do
    it 'returns the full name' do
      user = build(:user, name: 'John', patronymic: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end
end
