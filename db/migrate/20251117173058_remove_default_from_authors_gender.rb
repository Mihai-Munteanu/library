class RemoveDefaultFromAuthorsGender < ActiveRecord::Migration[8.1]
  def change
    change_column_default :authors, :gender, from: "male", to: nil
  end
end
