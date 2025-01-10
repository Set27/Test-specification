FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    patronymic { Faker::Name.middle_name }
    email { Faker::Internet.unique.email }
    age { Faker::Number.between(from: 1, to: 90) }
    nationality { Faker::Nation.nationality }
    country { Faker::Address.country }
    gender { [ 'male', 'female' ].sample }
    created_at { Time.now }
    updated_at { Time.now }
    full_name { "#{name} #{patronymic}" }
  end
end
