class User < ApplicationRecord
  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests

  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  validates_presence_of :name, :patronymic, :email, :age, :nationality, :gender
  validates_uniqueness_of :email, case_sensitive: false
  validates_inclusion_of :age, in: 1..90, message: "must be between 1 and 90"
  validates_inclusion_of :gender, in: %w[male female], message: "must be either 'male' or 'female'"

  def full_name
    "#{name} #{patronymic}"
  end
end
