class UsersController < ApplicationController
  def create
    outcome = Users::Create.run(user_params)

    respond_to do |format|
      if outcome.valid?
        result = outcome.result
        format.json { render json: result, status: :created }
      else
        @errors = result.errors
        format.json { render json: @errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :patronymic, :email, :age, :nationality, :country, :gender, interests: [], skills: "")
  end
end
