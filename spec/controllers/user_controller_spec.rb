require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    subject(:do_request) { post "/users", params: { user: params }, as: :json }

    let(:params) { valid_params }
    let(:valid_params) do
      {
        name: "John",
        patronymic: "Doe",
        email: "john@example.com",
        age: 30,
        nationality: "American",
        country: "USA",
        gender: "male",
        interests: [ "Programming", "Reading" ],
        skills: "Ruby, Rails"
      }
    end

    context "when valid params" do
      let(:created_user) { User.last }

      it 'returns correct status code with response' do
        do_request

        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to include(
          "id" => created_user.id,
          "name" => created_user.name,
          "patronymic" => created_user.patronymic,
          "email" => created_user.email,
          "age" => created_user.age,
          "nationality" => created_user.nationality,
          "country" => created_user.country,
          "gender" => created_user.gender
        )
      end

      it 'creates new user in DB' do
        expect { do_request }.to change { User.count }.by(1)
      end
    end

    context "when validation error" do
      let(:params) { valid_params.merge(name: "", email: "") }

      it 'returns unprocessable entity status code with errors messages' do
        do_request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to be_present
      end

      it 'does not create new user' do
        expect { do_request }.not_to change { User.count }
      end
    end
  end
end
