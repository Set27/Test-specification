class Users::Create < ActiveInteraction::Base
  hash :params do
    string :name
    string :patronymic
    string :email
    integer :age
    string :nationality
    string :country
    string :gender
    array :interests, default: []
    string :skills, default: ""
  end

  def execute
    User.transaction do
      user = create_user
      assign_interests_to(user)
      assign_skills_to(user)

      user
    end
  end

  private

  def create_user
    user_params = params.except(:interests, :skills)
    User.create(user_params)
  end

  def assign_interests_to(user)
    interests = Interest.where(name: params[:interests])

    user.interests << interests
    user.save
  end

  def assign_skills_to(user)
    skills = Skill.where(name: skills_array)

    user.skills << skills
    user.save
  end

  def skills_array
    params[:skills].split(",").map(&:strip).reject(&:empty?)
  end
end
