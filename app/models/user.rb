class User < ApplicationRecord
  include UserValidations

  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  def full_name
    "#{name} #{patronymic}"
  end
end
