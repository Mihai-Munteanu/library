class CreateLoans < ActiveRecord::Migration[8.1]

  def change
    create_table :loans do |t|
      t.references :member, foreign_key: true
      t.references :book, foreign_key: true
      t.datetime :start_date
      t.datetime :due_date
      t.datetime :return_date
      t.integer :status, default: 0
      t.text :notes
      t.json :metadata, default: {}
      t.time :paused_start_time, default: "00:12:00"
      t.time :paused_end_time, default: "00:13:00"


      t.index :start_date
      t.index :due_date
      t.index :return_date
      t.index :status

      t.timestamps
    end
  end
end
