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

ActiveRecord::Schema[8.1].define(version: 2025_11_26_073938) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.text "biography"
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.date "death_date"
    t.integer "gender"
    t.json "metadata"
    t.string "name"
    t.string "nationality"
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
    t.integer "status", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["status"], name: "index_books_on_status"
  end

  create_table "loans", force: :cascade do |t|
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "due_date"
    t.integer "member_id"
    t.json "metadata", default: {}
    t.text "notes"
    t.datetime "return_date"
    t.datetime "start_date"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_loans_on_book_id"
    t.index ["due_date"], name: "index_loans_on_due_date"
    t.index ["member_id"], name: "index_loans_on_member_id"
    t.index ["return_date"], name: "index_loans_on_return_date"
    t.index ["start_date"], name: "index_loans_on_start_date"
    t.index ["status"], name: "index_loans_on_status"
  end

  create_table "members", force: :cascade do |t|
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.date "birth_date"
    t.bigint "books_borrowed", default: 0
    t.bigint "books_returned", default: 0
    t.datetime "created_at", null: false
    t.float "discount_rate", default: 0.0
    t.string "email"
    t.integer "gender"
    t.boolean "is_active", default: true
    t.boolean "is_admin", default: false
    t.boolean "is_vip", default: false
    t.string "name"
    t.float "points", default: 0.0
    t.decimal "total_spent", precision: 10, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "books", "authors"
  add_foreign_key "loans", "books"
  add_foreign_key "loans", "members"
end
