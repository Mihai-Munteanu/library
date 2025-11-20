class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.text :description
      t.references :author, null: false, foreign_key: true
      t.date :publication_date
      t.integer :copies_sold
      t.float :price
      t.integer :pages

      t.timestamps
    end
  end
end
