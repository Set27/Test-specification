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
          skills: 'Ruby,Rails,RSpec'
        }
      }
    end

    before do
      %w[coding reading].each { |name| create(:interest, name:) }
      %w[Ruby Rails RSpec].each { |name| create(:skill, name:) }
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
          expect { described_class.run!(invalid_params) }.to raise_error(ActiveRecord::RecordInvalid,
                                                              /Age must be between 1 and 90/)
        end
      end

      context 'when email is not unique' do
        before do
          create(:user, { email: valid_params[:params][:email] })
        end

        it 'raises an error' do
          expect { described_class.run!(valid_params) }.to raise_error(ActiveRecord::RecordInvalid,
                                                            /Email has already been taken/)
        end
      end

      context 'when gender is invalid' do
        it 'raises an error' do
          invalid_params = valid_params.deep_merge(params: { gender: 'invalid' })
          expect { described_class.run!(invalid_params) }.to raise_error(ActiveRecord::RecordInvalid,
                                                                        /Gender must be either 'male' or 'female'/)
        end
      end
    end

    context 'when name is blank' do
      it 'raises an error' do
        missing_params = valid_params.deep_merge(params: { name: '' })
        expect { described_class.run!(missing_params) }.to raise_error(ActiveRecord::RecordInvalid,
                                                                      /Name can't be blank/)
      end
    end
  end
end
