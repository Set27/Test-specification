class User < ApplicationRecord
  has_many :user_interests
  has_many :interests, through: :user_interests

  has_many :user_skills
  has_many :skills, through: :user_skills

  validates_presence_of :name, :patronymic, :email, :age, :nationality, :gender
  validates_uniqueness_of :email
end
