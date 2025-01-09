require 'rails_helper'

RSpec.describe Users::Create do
  describe '#execute' do
    let(:valid_params) do
      {
        params: {
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
      }
    end

    before do
      Interest.create(name: 'coding')
      Interest.create(name: 'reading')

      Skill.create(name: 'Ruby')
      Skill.create(name: 'Rails')
      Skill.create(name: 'RSpec')
    end

    context 'with valid params' do
      it 'creates a user' do
        expect { described_class.run!(valid_params) }.to change(User, :count).by(1)
      end

      it 'assigns interests to the user' do
        user = described_class.run!(valid_params)
        expect(user.interests.pluck(:name)).to match_array([ 'coding', 'reading' ])
      end

      it 'assigns skills to the user' do
        user = described_class.run!(valid_params)
        expect(user.skills.pluck(:name)).to match_array([ 'Ruby', 'Rails', 'RSpec' ])
      end
    end

    context 'with invalid params' do
      context 'when age is out of range' do
        it 'raises an error' do
          invalid_params = valid_params.deep_merge(params: { age: 91 })
          expect { described_class.run!(invalid_params) }.to raise_error(ActiveInteraction::InvalidInteractionError,
                                                              /Age must be between 1 and 90/)
        end
      end

      context 'when email is not unique' do
        before do
          User.create!(
            name: 'Existing',
            patronymic: 'User',
            email: valid_params[:params][:email],
            age: 30,
            nationality: 'Belarusian',
            country: 'Belarus',
            gender: 'male',
          )
        end

        it 'raises an error' do
          expect { described_class.run!(valid_params) }.to raise_error(ActiveInteraction::InvalidInteractionError,
                                                            /Email has already been taken/)
        end
      end

      context 'when gender is invalid' do
        it 'raises an error' do
          invalid_params = valid_params.deep_merge(params: { gender: 'invalid' })
          expect { described_class.run!(invalid_params) }.to raise_error(ActiveInteraction::InvalidInteractionError,
                                                                        /Gender must be either 'male' or 'female'/)
        end
      end
    end
  end
end
