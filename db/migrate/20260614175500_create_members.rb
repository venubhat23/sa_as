class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.bigint :user_id
      t.string :membership_number
      t.bigint :chapter_id
      t.bigint :forum_id
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.date :dob
      t.text :address
      t.string :city
      t.string :state
      t.string :pincode
      t.string :company_name
      t.string :gst_number
      t.string :pan_number
      t.bigint :business_category_id
      t.bigint :business_specialty_id
      t.string :website
      t.string :linkedin_url
      t.string :photo
      t.bigint :membership_plan_id
      t.date :joining_date
      t.date :renewal_date
      t.integer :membership_status, default: 0
      t.string :pan_document
      t.string :gst_document
      t.string :aadhar_document
      t.string :business_registration_document
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
