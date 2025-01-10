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
    user = create_user
    assign_interests(user)
    assign_skills(user)

    user
  end

  private

  def create_user
    user_params = params.except(:interests, :skills)
    User.create(user_params)
  end

  def assign_interests(user)
    interests = Interest.where(name: params[:interests])
    user.interests << interests
    # I have left original save methods for each assign method (assign_interests, assign_skills)
    # That is depend on business logic I guess
    # Maybe skills less important than interests
    user.save!
  end

  def assign_skills(user)
    skills = params[:skills].split(",").map do |skill_name|
      # Could be find_or_create_by I guess this depend on business logic too
      Skill.find_by(name: skill_name.strip)
    end.compact

    user.skills = skills
    user.save
  end
end
