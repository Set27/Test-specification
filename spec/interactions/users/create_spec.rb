require 'rails_helper'

RSpec.describe Users::Create do
  describe '#execute' do
    let(:params) do
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
      subject { described_class.run(params) }

      let(:user) { User.find_by(email: params[:email]) }
      let(:expected_skills) { params[:skills].split(',').map(&:strip) }

      before { subject }

      it 'creates a user' do
        expect(user).to be_present
      end

      it 'assigns the correct interests to the user' do
        expect(user.interests.map(&:name)).to match_array(params[:interests])
      end

      it 'assigns the correct skills to the user' do
        expect(user.skills.map(&:name)).to match_array(expected_skills)
      end

      it 'sets the user attributes correctly' do
        expect(user.name).to eq(params[:name])
        expect(user.patronymic).to eq(params[:patronymic])
        expect(user.age).to eq(params[:age])
        expect(user.nationality).to eq(params[:nationality])
        expect(user.country).to eq(params[:country])
        expect(user.gender).to eq(params[:gender])
      end
    end

    shared_examples "an invalid result" do |expected_errors|
      it { expect(subject).to be_invalid }
      it do
        expected_errors.each do |field, messages|
          expect(subject.errors[field]).to include(*messages)
        end
      end
    end

    context 'with invalid params' do
      context 'when age is out of range' do
        let(:invalid_params) { params.merge(age: 91) }
        subject { described_class.run(invalid_params) }
        include_examples "an invalid result", age: [ 'must be between 1 and 90' ]
      end

      context 'when email is not unique' do
        before { create(:user, email: params[:email]) }
        subject { described_class.run(params) }
        include_examples "an invalid result", email: [ 'has already been taken' ]
      end

      context 'when gender is invalid' do
        let(:invalid_params) { params.merge(gender: 'invalid') }
        subject { described_class.run(invalid_params) }
        include_examples "an invalid result", gender: [ "must be either 'male' or 'female'" ]
      end

      context 'when name is blank' do
        let(:missing_params) { params.merge(name: '') }
        subject { described_class.run(missing_params) }
        include_examples "an invalid result", name: [ "can't be blank" ]
      end
    end
  end
end
