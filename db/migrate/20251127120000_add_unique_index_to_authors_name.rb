class AddUniqueIndexToAuthorsName < ActiveRecord::Migration[7.1]
  def change
    add_index :authors, :name, unique: true, if_not_exists: true
  end
end
