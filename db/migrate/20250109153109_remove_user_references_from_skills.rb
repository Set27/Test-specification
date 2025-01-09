class RemoveUserReferencesFromSkills < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :skills, :users
    remove_column :skills, :user_id, :integer
  end
end
