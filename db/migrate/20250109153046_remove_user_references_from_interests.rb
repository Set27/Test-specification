class RemoveUserReferencesFromInterests < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :interests, :users
    remove_column :interests, :user_id, :integer
  end
end
