class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :biography
      t.date :birth_date
      t.date :death_date
      t.string :nationality
      t.string :gender, default: "male"
      t.json :awards
      t.json :publications
      t.json :achievements

      t.index :name
      t.index :birth_date
      t.index :death_date
      t.index :nationality
      t.index :gender

      t.timestamps
    end
  end
end
