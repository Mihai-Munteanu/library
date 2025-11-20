# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_20_040548) do
  create_table "authors", force: :cascade do |t|
    t.json "achievements"
    t.json "awards"
    t.text "biography"
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.date "death_date"
    t.string "gender"
    t.string "name"
    t.string "nationality"
    t.json "publications"
    t.datetime "updated_at", null: false
    t.index ["birth_date"], name: "index_authors_on_birth_date"
    t.index ["death_date"], name: "index_authors_on_death_date"
    t.index ["gender"], name: "index_authors_on_gender"
    t.index ["name"], name: "index_authors_on_name"
    t.index ["nationality"], name: "index_authors_on_nationality"
  end

  create_table "books", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "copies_sold"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "isbn"
    t.integer "pages"
    t.float "price"
    t.date "publication_date"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
  end

  add_foreign_key "books", "authors"
end
