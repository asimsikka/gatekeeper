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

ActiveRecord::Schema[8.0].define(version: 2025_07_11_070112) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "content_spaces", force: :cascade do |t|
    t.string "name"
    t.integer "min_age", default: 0, null: false
    t.integer "max_age", default: 150, null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "name"], name: "index_content_spaces_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_content_spaces_on_organization_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.integer "age_rating", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "content_space_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age_rating"], name: "index_contents_on_age_rating"
    t.index ["content_space_id"], name: "index_contents_on_content_space_id"
    t.index ["user_id"], name: "index_contents_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "organization_id", null: false
    t.string "role", default: "member", null: false
    t.string "status", default: "invited", null: false
    t.string "invite_email"
    t.string "invitation_token"
    t.datetime "invitation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitation_token"], name: "index_memberships_on_invitation_token", unique: true
    t.index ["invite_email"], name: "index_memberships_on_invite_email"
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["user_id", "organization_id"], name: "index_memberships_on_user_id_and_organization_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "location"
    t.string "email_domain"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "parental_consents", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "guardian_email", null: false
    t.string "token", null: false
    t.boolean "approved", default: false, null: false
    t.datetime "approved_at"
    t.datetime "sent_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_parental_consents_on_token", unique: true
    t.index ["user_id"], name: "index_parental_consents_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_of_birth"
    t.string "first_name"
    t.string "last_name"
    t.boolean "parental_consent", default: false, null: false
    t.string "consent_token"
    t.datetime "consent_sent_at"
    t.datetime "consent_approved_at"
    t.index ["consent_token"], name: "index_users_on_consent_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "content_spaces", "organizations"
  add_foreign_key "contents", "content_spaces"
  add_foreign_key "contents", "users"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "parental_consents", "users"
end
