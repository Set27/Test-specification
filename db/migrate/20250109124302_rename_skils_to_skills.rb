class RenameSkilsToSkills < ActiveRecord::Migration[8.0]
  def change
    rename_table :skils, :skills
  end
end
