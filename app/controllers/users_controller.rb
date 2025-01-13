class UsersController < ApplicationController
  def create
    user_creation = Users::Create.run(permitted_user_params)

    if user_creation.valid?
      created_user = user_creation.result
      render json: created_user, status: :created
    else
      creation_errors = user_creation.errors
      render json: creation_errors, status: :unprocessable_entity
    end
  end

  private

  def permitted_user_params
    params.require(:user).permit(:name, :patronymic, :email, :age, :nationality, :country, :gender, interests: [], skills: "")
  end
end
