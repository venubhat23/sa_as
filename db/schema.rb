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

ActiveRecord::Schema[8.0].define(version: 2026_06_14_181900) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendance_rules", force: :cascade do |t|
    t.string "rule_type"
    t.string "value"
    t.text "description"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audit_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.string "action"
    t.string "resource_type"
    t.bigint "resource_id"
    t.text "changes_json"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_specialties", force: :cascade do |t|
    t.string "name"
    t.bigint "business_category_id"
    t.text "description"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.bigint "forum_id"
    t.text "description"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "committee_assignments", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "committee_role_id"
    t.bigint "chapter_id"
    t.date "start_date"
    t.date "end_date"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "committee_roles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_templates", force: :cascade do |t|
    t.string "name"
    t.string "subject"
    t.text "body"
    t.string "template_type"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_registrations", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "member_id"
    t.date "registration_date"
    t.string "payment_status", default: "pending"
    t.string "attendance_status", default: "registered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "event_type"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "venue"
    t.text "description"
    t.integer "capacity"
    t.decimal "registration_fee", precision: 12, scale: 2
    t.string "status", default: "upcoming"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fee_collections", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "renewal_id"
    t.decimal "amount", precision: 12, scale: 2
    t.string "payment_mode"
    t.date "payment_date"
    t.string "receipt_number"
    t.text "notes"
    t.string "status", default: "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forums", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "code"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_settings", force: :cascade do |t|
    t.string "key"
    t.text "value"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guest_attendances", force: :cascade do |t|
    t.bigint "weekly_meeting_id"
    t.bigint "guest_id"
    t.string "attendance_status", default: "present"
    t.datetime "check_in_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guests", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "company_name"
    t.bigint "business_category_id"
    t.bigint "invited_by_member_id"
    t.bigint "chapter_id"
    t.integer "lifecycle_status", default: 0
    t.date "visit_date"
    t.text "notes"
    t.datetime "converted_at"
    t.bigint "converted_member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "pincode"
    t.bigint "region_id"
    t.bigint "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meeting_attendances", force: :cascade do |t|
    t.bigint "weekly_meeting_id"
    t.bigint "member_id"
    t.integer "attendance_status", default: 0
    t.datetime "check_in_time"
    t.string "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.bigint "user_id"
    t.string "membership_number"
    t.bigint "chapter_id"
    t.bigint "forum_id"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.date "dob"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "pincode"
    t.string "company_name"
    t.string "gst_number"
    t.string "pan_number"
    t.bigint "business_category_id"
    t.bigint "business_specialty_id"
    t.string "website"
    t.string "linkedin_url"
    t.string "photo"
    t.bigint "membership_plan_id"
    t.date "joining_date"
    t.date "renewal_date"
    t.integer "membership_status", default: 0
    t.string "pan_document"
    t.string "gst_document"
    t.string "aadhar_document"
    t.string "business_registration_document"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "membership_plans", force: :cascade do |t|
    t.string "name"
    t.integer "duration_months"
    t.decimal "fee_amount", precision: 12, scale: 2
    t.text "description"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "membership_renewals", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "plan_id"
    t.date "renewal_date"
    t.date "expiry_date"
    t.decimal "amount", precision: 12, scale: 2
    t.string "payment_status", default: "pending"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "body"
    t.string "notification_type"
    t.boolean "is_read", default: false
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "office_darshan_visitors", force: :cascade do |t|
    t.bigint "office_darshan_id"
    t.bigint "member_id"
    t.string "visitor_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "office_darshans", force: :cascade do |t|
    t.bigint "host_member_id"
    t.date "visit_date"
    t.text "purpose"
    t.text "feedback"
    t.string "status", default: "scheduled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "one_to_ones", force: :cascade do |t|
    t.bigint "member1_id"
    t.bigint "member2_id"
    t.date "meeting_date"
    t.string "location"
    t.text "agenda"
    t.text "discussion_notes"
    t.text "action_items"
    t.string "status", default: "scheduled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_gateway_settings", force: :cascade do |t|
    t.string "gateway_name"
    t.string "api_key"
    t.string "api_secret"
    t.boolean "is_active", default: false
    t.string "environment", default: "test"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.bigint "role_id"
    t.string "module_name"
    t.boolean "can_view", default: false
    t.boolean "can_create", default: false
    t.boolean "can_edit", default: false
    t.boolean "can_delete", default: false
    t.boolean "can_export", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "referral_rules", force: :cascade do |t|
    t.string "rule_type"
    t.string "value"
    t.text "description"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "referrals", force: :cascade do |t|
    t.string "referral_number"
    t.date "referral_date"
    t.bigint "given_by_member_id"
    t.bigint "given_to_member_id"
    t.string "client_name"
    t.string "client_phone"
    t.decimal "referral_value", precision: 12, scale: 2
    t.text "notes"
    t.integer "workflow_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.text "description"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "status", default: "active"
    t.boolean "is_system_role", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sidebar_accesses", force: :cascade do |t|
    t.bigint "role_id"
    t.string "menu_key"
    t.boolean "is_enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sms_templates", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.string "template_type"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "thank_you_slips", force: :cascade do |t|
    t.bigint "referral_id"
    t.decimal "business_value", precision: 12, scale: 2
    t.string "invoice_number"
    t.string "client_name"
    t.bigint "received_by_member_id"
    t.bigint "thanked_to_member_id"
    t.date "date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.bigint "role_id"
    t.string "name"
    t.string "phone"
    t.string "status", default: "active"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "weekly_meetings", force: :cascade do |t|
    t.bigint "chapter_id"
    t.date "meeting_date"
    t.string "meeting_type"
    t.string "venue"
    t.text "agenda"
    t.string "status", default: "scheduled"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "whatsapp_templates", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.string "template_type"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
