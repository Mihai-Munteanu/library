class CreateMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.date :birth_date
      t.string :gender
      t.boolean :is_active, default: true
      t.boolean :is_vip, default: false
      t.boolean :is_admin, default: false
      t.decimal :balance, precision: 10, scale: 2, default: 0.00
      t.decimal :total_spent, precision: 10, scale: 2, default: 0.00
      t.float :discount_rate, default: 0.00
      t.float :points, default: 0.00
      t.bigint :books_borrowed, default: 0
      t.bigint :books_returned, default: 0

      t.timestamps
    end
  end
end
