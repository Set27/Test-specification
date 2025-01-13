class Users::Create < ActiveInteraction::Base
  include UserValidations

  string :name
  string :patronymic
  string :email
  integer :age
  string :nationality
  string :country
  string :gender
  array :interests, default: []
  string :skills, default: ""

  def execute
    user = build_user
    assign_interests_to(user)
    assign_skills_to(user)

    user.save!

    user
  end

  private

  def build_user
    User.new(user_params)
  end

  def assign_interests_to(user)
    interests = Interest.where(name: self.interests)
    user.interests = interests
  end

  def assign_skills_to(user)
    skills = Skill.where(name: skills_array)
    user.skills = skills
  end

  def skills_array
    skills.split(",").map(&:strip).reject(&:empty?)
  end

  def user_params
    {
      name: name,
      patronymic: patronymic,
      email: email,
      age: age,
      nationality: nationality,
      country: country,
      gender: gender
    }
  end
end
