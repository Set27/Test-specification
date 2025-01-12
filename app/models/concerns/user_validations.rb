module UserValidations
  extend ActiveSupport::Concern

  included do
    validates_presence_of :name, :patronymic, :email, :age, :nationality, :gender
    validates_inclusion_of :age, in: 1..90, message: "must be between 1 and 90"
    validates_inclusion_of :gender, in: %w[male female], message: "must be either 'male' or 'female'"

    validate :unique_email
  end

  private

  def unique_email
    if User.exists?(email: email)
      errors.add(:email, "has already been taken")
    end
  end
end
