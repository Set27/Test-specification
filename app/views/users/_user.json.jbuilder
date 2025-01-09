json.extract! user, :id, :name, :patronymic, :email, :age, :nationality, :country, :gender, :created_at, :updated_at
json.url user_url(user, format: :json)
