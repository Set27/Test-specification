FactoryBot.define do
  factory :skill do
    name { Faker::Games::LeagueOfLegends.summoner_spell }
  end
end
