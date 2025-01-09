class Users::Create < ActiveInteraction::Base
  hash :params do
    string :name
    string :patronymic
    string :email
    integer :age
    string :nationality
    string :country
    string :gender, default: nil, in: %w[male female]
    array :interests, default: []
    string :skills, default: ''
  end

  validate :validate_age
  validate :validate_gender
  validate :validate_email_uniqueness

  def execute
    user = create_user
    assign_interests(user)
    assign_skills(user)
    user
  end

  private

  def validate_age
    errors.add(:age, 'must be between 1 and 90') unless (1..90).cover?(params[:age])
  end

  def validate_email_uniqueness
    errors.add(:email, 'has already been taken') if User.exists?(email: params[:email])
  end

  def create_user
    user_full_name = "#{params[:surname]} #{params[:name]} #{params[:patronymic]}"
    user_params = params.except(:interests, :skills)
    User.create(user_params.merge(full_name: user_full_name))
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
    skills = params[:skills].split(',').map do |skill_name|
      Skill.find_by(name: skill_name.strip)
    end.compact

    user.skills = skills
    user.save
  end
end
