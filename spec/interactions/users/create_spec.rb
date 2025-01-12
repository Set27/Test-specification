require 'rails_helper'

RSpec.describe Users::Create do
  describe '#execute' do
    let(:valid_params) do
      {
        name: 'Matvei',
        patronymic: 'Andreevich',
        email: 'matvei.traz@gmail.com',
        age: 22,
        nationality: 'Belarusian',
        country: 'Belarus',
        gender: 'male',
        interests: [ 'coding', 'reading' ],
        skills: 'Ruby, Rails, RSpec'
      }
    end

    before do
      %w[coding reading].each { |name| create(:interest, name:) }
      %w[Ruby Rails RSpec].each { |name| create(:skill, name:) }
    end

    context 'with valid params' do
      let(:result) { described_class.run(valid_params) }

      it 'creates a user' do
        expect { result }.to change(User, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:result) { described_class.run(invalid_params) }

      context 'when age is out of range' do
        let(:invalid_params) { valid_params.merge(age: 91) }

        it 'stores errors' do
          expect(result).to be_invalid
          expect(result.errors[:age]).to include('must be between 1 and 90')
        end
      end

      context 'when email is not unique' do
        before { create(:user, email: valid_params[:email]) }

        let(:result) { described_class.run(valid_params) }

        it 'stores errors' do
          expect(result).to be_invalid
          expect(result.errors[:email]).to include('has already been taken')
        end
      end

      context 'when gender is invalid' do
        let(:invalid_params) { valid_params.merge(gender: 'invalid') }

        it 'stores errors' do
          expect(result).to be_invalid
          expect(result.errors[:gender]).to include("must be either 'male' or 'female'")
        end
      end

      context 'when name is blank' do
        let(:invalid_params) { valid_params.merge(name: '') }

        it 'stores errors' do
          expect(result).to be_invalid
          expect(result.errors[:name]).to include("can't be blank")
        end
      end
    end
  end
end
